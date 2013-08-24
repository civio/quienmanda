class AddExtraWideToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :extra_wide, :boolean
  end
end
