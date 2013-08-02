class AddPublishedToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :published, :boolean
    add_index :entities, :published
  end
end
