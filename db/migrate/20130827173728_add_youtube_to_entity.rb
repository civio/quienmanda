class AddYoutubeToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :youtube_page, :string
  end
end
