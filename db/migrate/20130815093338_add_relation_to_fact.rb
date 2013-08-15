class AddRelationToFact < ActiveRecord::Migration
  def change
    add_reference :facts, :relation, index: true
  end
end
