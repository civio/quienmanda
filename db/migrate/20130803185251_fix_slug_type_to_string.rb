class FixSlugTypeToString < ActiveRecord::Migration
  def change
    change_column :entities, :slug, :string
    change_column :posts, :slug, :string
  end
end
