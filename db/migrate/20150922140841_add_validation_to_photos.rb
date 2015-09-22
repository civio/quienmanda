class AddValidationToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :validated, :boolean, :default => true, :null => false
  end
end
