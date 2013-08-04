# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :public_post, class: Post do
    title "A public post"
    slug "a-public-post"
    content "MyText"
    published true
    author
  end

  factory :private_post, class: Post do
    title "A private post"
    slug "a-private-post"
    content "MyText"
    published false
    author
  end
end
