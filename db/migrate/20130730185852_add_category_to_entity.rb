class AddCategoryToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :category, :string
  end
end
