class RemoveTitleAndFooterForPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :title
    remove_column :photos, :slug
    add_column :photos, :footer, :string
  end
end
