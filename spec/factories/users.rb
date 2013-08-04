FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user, aliases: [:author] do
    name "Pedro"
    email
    password "foobar123"
    admin false
  end

  factory :admin, class: User do
    name "Admin"
    email
    password "foobar123"
    admin true
  end
end
