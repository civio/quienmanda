class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

  has_paper_trail

  mount_uploader :photo, PhotoUploader

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
      begin
        uri = URI(link['href'])
        uri.host =~ /(^|\.)#{domain_name}$/           # Allow subdomains too
        next unless $~

        extractors.each do |extractor|                # If any extractor matches...
          uri.path =~ extractor[:regex]
          next unless $~

          ref = extractor[:method].call($1)           # Try to find related object
          if !ref.nil?
            link['target'] = '_blank'                 # Add a _blank target
            references << ref                         # Keep the related object, if found
          else
            link['class'] = 'broken-link'             # Mark the link as broken for display
          end
          break # extractor loop
        end
      rescue URI::InvalidURIError
        # Nothing to see here, move along (we just ignore invalid links)
      end
    end
    self.content = doc.to_html                        # Save changes and...
    references                                        # return found references
  end
end
