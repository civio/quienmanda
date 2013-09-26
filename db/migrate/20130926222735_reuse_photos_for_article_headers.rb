class ReusePhotosForArticleHeaders < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      rename_column :posts, :photo, :old_photo
      t.references :photo, index: true
    end
  end
end
