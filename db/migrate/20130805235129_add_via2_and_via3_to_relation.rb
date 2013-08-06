class AddVia2AndVia3ToRelation < ActiveRecord::Migration
  def change
    add_column :relations, :via2, :string
    add_column :relations, :via3, :string
  end
end
