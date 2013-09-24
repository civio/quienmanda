class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.json :data

      t.timestamps
    end
  end
end
