class Photo < ActiveRecord::Base
  has_many :annotations, dependent: :delete_all
  has_many :related_entities, -> { order('priority asc') }, through: :annotations, source: :entity

  has_many :posts_as_header, class_name: Post # It can be used as header in many posts

  has_many :mentions, as: :mentionee, inverse_of: :mentionee, dependent: :delete_all
  has_many :related_posts, -> { order('published_at desc') }, through: :mentions, source: :post

  has_paper_trail

  include PgSearch
  multisearchable :against => [:footer], :if => :published?

  mount_uploader :file, PhotoUploader

  acts_as_taggable

  scope :published, -> { where(published: true) }

  # Navigate across photo objects
  scope :next, ->(photo) { where("updated_at > ?", photo.updated_at).order("updated_at ASC") }
  scope :previous, ->(photo) { where("updated_at < ?", photo.updated_at).order("updated_at DESC") }
end
