class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User
  belongs_to :photo # Don't get confused, we _have_ a header photo

  has_paper_trail

  include PgSearch
  multisearchable :against => [:title, :content], :if => :published?

  acts_as_url :title, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  validates :title, presence: true, uniqueness: true
  validates :author, presence: true

  scope :published, -> { where(published: true) }

  # Extract references to other entities from content
  def extract_references(domain_name, extractors)
    references = []
    doc = Nokogiri::HTML::DocumentFragment.parse(self.content)
    doc.css('a').each do |link|                       # Check all links
      result = lookup_link(domain_name, extractors, link)
      references << result unless result.nil?         # Keep the related object, if found
    end
    self.content = doc.to_html                        # Save changes and...
    references                                        # return found references
  end

  private

    def lookup_link(domain_name, extractors, link)
      begin
        return if link['href'].blank?                 # Nothing to do...
        uri = URI(link['href'])
        uri.host =~ /(^|\.)#{domain_name}$/           # Allow subdomains too
        return nil unless $~

        extractors.each do |extractor|                # If any extractor matches...
          uri.path =~ /^#{extractor[:prefix]}\/(.*)$/
          next unless $~

          ref = extractor[:method].call($1)           # Try to find related object
          if !ref.nil?
            link['target'] = '_blank'                 # Add a _blank target
          else
            link['class'] = 'broken-link'             # Mark the link as broken for display
          end
          return ref
        end
      rescue URI::InvalidURIError
        # Nothing to see here, move along (we just ignore invalid links)
      end
      link['class'] = 'unknown-link'                  # Mark the link as unknown for display
      nil
    end
end
