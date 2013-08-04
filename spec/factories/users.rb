FactoryGirl.define do
  factory :user do
    name "Pedro"
    email "foobar@example.com"
    password "foobar123"
    admin false
  end

  factory :admin, class: User do
    name "Admin"
    email "foobaradmin@example.com"
    password "foobar123"
    admin true
  end
end
