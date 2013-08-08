class MakePriorityAString < ActiveRecord::Migration
  def change
    change_column :entities, :priority, :string, null: false, limit: 1
  end
end
