class RemoveOldPhotoInPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :old_photo
  end
end
