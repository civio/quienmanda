class CreateRelationTypes < ActiveRecord::Migration
  def change
    create_table :relation_types do |t|
      t.string :description

      t.timestamps
    end

    remove_column :relations, :relation
    add_column :relations, :relation_type_id, :integer, null: false
  end
end
