class AddFeaturedToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :featured, :boolean, default: false
  end
end
