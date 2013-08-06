# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :public_photo, class: Photo do
    footer "A public photo"
    published true
  end

  factory :private_photo, class: Photo do
    footer "A private photo"
    published false
  end
end
