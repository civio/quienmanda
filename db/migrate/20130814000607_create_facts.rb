class CreateFacts < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :facts do |t|
      t.string :importer
      t.hstore :properties
    end
    add_index :facts, :properties
  end
end
