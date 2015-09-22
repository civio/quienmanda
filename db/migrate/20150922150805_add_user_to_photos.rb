class AddUserToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :author_id, :integer, references: :users
    add_index :photos, :author_id
  end
end