class AddExtraEntityFields < ActiveRecord::Migration
  def change
    change_column :entities, :name, :string, :null => false   # required
    change_column :entities, :category, :string, :null => false   # required

    add_column :entities, :priority, :integer, :null => false # required
    add_column :entities, :short_name, :string

    add_column :entities, :twitter_handle, :string
    add_column :entities, :wikipedia_page, :string
    add_column :entities, :facebook_page, :string
    add_column :entities, :flickr_page, :string
    add_column :entities, :linkedin_page, :string

    add_column :entities, :notes, :text
  end
end
