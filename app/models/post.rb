class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

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
end
