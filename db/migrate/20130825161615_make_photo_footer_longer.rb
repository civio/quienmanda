class MakePhotoFooterLonger < ActiveRecord::Migration
  def change
    change_column :photos, :footer, :text
  end
end
