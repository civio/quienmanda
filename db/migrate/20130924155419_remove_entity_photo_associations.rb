class RemoveEntityPhotoAssociations < ActiveRecord::Migration
  def change
    drop_table :entity_photo_associations
  end
end
