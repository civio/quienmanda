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
    doc.css('a').each do |link|                         # Check all links
      begin
        uri = URI(link['href'])
        if uri.host =~ /(^|\.)#{domain_name}$/            # Allow subdomains too
          extractors.each do |extractor|                  # If any extractor matches...
            if uri.path =~ extractor[:regex] 
              link['target'] = '_blank'                   # Add a _blank target
              references << extractor[:method].call($1)   # Keep the related object
              break # extractor loop
            end
          end
        end
      rescue URI::InvalidURIError
        # Nothing to see here, move along
      end
    end
    self.content = doc.to_html                          # Save changes and...
    references                                          # return found references
  end
end
