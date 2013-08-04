# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :public_photo, class: Photo do
    title "A public photo"
    slug "a-public-photo"
    published true
  end

  factory :private_photo, class: Photo do
    title "A private photo"
    slug "a-private-photo"
    published false
  end
end
