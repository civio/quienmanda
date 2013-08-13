class EntityPhotoAssociation < ActiveRecord::Base
  belongs_to :photo
  belongs_to :entity

  # RailsAdmin configuration
  rails_admin do
    visible false
  end
end