class Photo < ActiveRecord::Base
  has_many :annotations, dependent: :delete_all
  has_many :related_entities, through: :annotations, source: :entity

  has_paper_trail

  include PgSearch
  multisearchable :against => [:footer], :if => :published?

  mount_uploader :file, PhotoUploader

  acts_as_taggable

  scope :published, -> { where(published: true) }
end
