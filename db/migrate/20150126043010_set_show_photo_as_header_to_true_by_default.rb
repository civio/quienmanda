class SetShowPhotoAsHeaderToTrueByDefault < ActiveRecord::Migration
  def change
    change_column :posts, :show_photo_as_header, :boolean, :default => :true
  end
end
