class AddSlugToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :slug, :string
    add_index :photos, :slug

    Photo.initialize_urls
  end
end
