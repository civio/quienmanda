class SimplifyEntityCategory < ActiveRecord::Migration
  def change
    remove_column :entities, :category

    add_column :entities, :person, :boolean, null: false, default: true
    add_index :entities, :person
  end
end
