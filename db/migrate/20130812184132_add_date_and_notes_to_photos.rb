class AddDateAndNotesToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :date, :date
    add_column :photos, :notes, :text
  end
end
