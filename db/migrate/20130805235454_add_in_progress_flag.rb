class AddInProgressFlag < ActiveRecord::Migration
  def change
    add_column :photos, :needs_work, :boolean, default: true, null: false
    add_column :posts, :needs_work, :boolean, default: true, null: false
    add_column :entities, :needs_work, :boolean, default: true, null: false
    add_column :relations, :needs_work, :boolean, default: false, null: false
  end
end
