class AddSlugToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :slug, :text
    add_index :entities, :slug

    Entity.initialize_urls
  end
end
