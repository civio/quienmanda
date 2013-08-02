class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  scope :published, -> { where(published: true) }
end
