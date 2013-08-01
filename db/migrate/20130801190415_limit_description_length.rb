class LimitDescriptionLength < ActiveRecord::Migration
  def change
    change_column :entities, :description, :string, limit: 90
  end
end
