class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
    	t.string :title, null: false
    	t.text :description
      t.string :slug
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end
