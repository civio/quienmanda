class RelateEntitiesAndPhotosViaAnnotations < ActiveRecord::Migration
  def change
    change_table :annotations do |t|
      t.references :photo, index: true
      t.references :entity, index: true
    end
  end
end
