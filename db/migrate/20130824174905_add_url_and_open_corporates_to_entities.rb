class AddUrlAndOpenCorporatesToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :web_page, :string
    add_column :entities, :open_corporates_page, :string
  end
end
