class CreateRelationFacts < ActiveRecord::Migration
  def change
    create_table :facts_relations do |t|
      t.references :relation, index: true
      t.references :fact, index: true
    end
    remove_reference :facts, :relation, index: true
  end
end
