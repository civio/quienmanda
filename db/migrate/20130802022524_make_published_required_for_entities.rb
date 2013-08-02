class MakePublishedRequiredForEntities < ActiveRecord::Migration
  def change
    change_column :entities, :published, :boolean, null: false, default: false
  end
end
