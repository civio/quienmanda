class Photo < ActiveRecord::Base
  has_many :entity_photo_associations, dependent: :delete_all
  has_many :related_entities, through: :entity_photo_associations, source: :entity

  mount_uploader :file, PhotoUploader

  acts_as_taggable

  scope :published, -> { where(published: true) }
end
