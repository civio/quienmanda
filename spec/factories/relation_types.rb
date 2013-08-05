# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relation_type do
    description "a relation"

    # Avoid creating multiple copies of the same item
    initialize_with { RelationType.find_or_create_by(description: description)}
  end
end
