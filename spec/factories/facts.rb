# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fact do
    ignore do
      role 'A role'
      source 'A source entity'
      target 'A target entity'
    end
    importer "An importer"
    properties {{ 'Nombre' => source, 'Cargo' => role, 'Empresa' => target }}
  end
end
