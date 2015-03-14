class RemoveTopicIdsFromPhotosAndEntities < ActiveRecord::Migration
  def change
    remove_column :entities, :topic_id
    remove_column :photos, :topic_id
  end
end
