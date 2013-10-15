class PublishEntitiesByDefault < ActiveRecord::Migration
  def change
    change_column :entities, :published, :boolean, default: true, null: false
  end
end
