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
    Nokogiri::HTML(content).css('a').each do |link|
      uri = URI(link['href'])
      if uri.host =~ /(^|\.)#{domain_name}$/  # Allow subdomains too
        extractors.each do |extractor|
          if uri.path =~ extractor[:regex] 
            references << extractor[:method].call($1)
            break # extractor loop
          end
        end
      end
    end
    references
  end
end
