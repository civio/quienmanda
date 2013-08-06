class AddSlugToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :slug, :string
    add_index :photos, :slug
  end
end
