class AddExtraPostFields < ActiveRecord::Migration
  def change
    add_column :posts, :author_id, :integer, references: :users

    add_column :posts, :title, :string, :null => false # required
    add_column :posts, :published, :boolean, :null => false, :default => false # required
    add_column :posts, :notes, :text
  end
end
