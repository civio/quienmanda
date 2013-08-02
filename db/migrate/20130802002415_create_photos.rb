class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :file
      t.string :title
      t.string :copyright
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :photos, :published
  end
end
