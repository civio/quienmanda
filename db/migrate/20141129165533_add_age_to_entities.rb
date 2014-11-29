class AddAgeToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :age, :integer
  end
end
