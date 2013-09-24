class StoreJsonAsText < ActiveRecord::Migration
  def change
    change_column :annotations, :data, :text
  end
end
