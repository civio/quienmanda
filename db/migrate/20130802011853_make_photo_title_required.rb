class MakePhotoTitleRequired < ActiveRecord::Migration
  def change
    change_column :photos, :title, :string, null: false
  end
end
