# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :public_person, class: Entity do
    person true
    name "A public person"
    slug "a-public-person"
    published true
    priority '1'
  end

  factory :private_person, class: Entity do
    person true
    name "A private person"
    slug "a-private-person"
    published false
    priority '1'
  end

  factory :public_organization, class: Entity do
    person false
    name "A public organization"
    slug "a-public-organization"
    published true
    priority '1'
  end

  factory :private_organization, class: Entity do
    person false
    name "A private organization"
    slug "a-private-organization"
    published false
    priority '1'
  end
end

