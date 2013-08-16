# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fact do
    ignore do
      source 'A source entity'
      role 'A role'
      target 'A target entity'
    end
    importer "An importer"
    properties {{ :source => source, :role => role, :target => target }}
  end
end
