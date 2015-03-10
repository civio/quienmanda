class AddFeaturedOrderToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :featured_order, :integer, default: 0
  end
end
