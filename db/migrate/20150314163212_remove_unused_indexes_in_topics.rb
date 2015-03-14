class RemoveUnusedIndexesInTopics < ActiveRecord::Migration
  def change
    remove_index :topics, :entity_id
    remove_index :topics, :photo_id
  end
end
