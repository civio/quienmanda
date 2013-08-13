class CreateEntityPhotoAssociations < ActiveRecord::Migration
  def change
    create_table :entity_photo_associations do |t|
      t.references :photo, index: true
      t.references :entity, index: true
    end
  end
end
