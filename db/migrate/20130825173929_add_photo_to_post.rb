class AddPhotoToPost < ActiveRecord::Migration
  def change
    add_column :posts, :photo, :string
    add_column :posts, :show_photo_as_header, :boolean, :default => :false
  end
end
