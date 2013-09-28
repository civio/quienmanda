class AddFeaturedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :featured, :boolean, null: true, default: false
  end
end
