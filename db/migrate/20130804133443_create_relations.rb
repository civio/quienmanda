class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.references :source, index: true, null: false
      t.string :relation, null: false
      t.references :target, index: true, null: false
      t.string :via
      t.date :from
      t.date :to
      t.date :at
      t.boolean :published
      t.text :notes

      t.timestamps
    end
  end
end
