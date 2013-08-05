# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relation do
    relation_type
    via "http://www.google.es"
    published false
    # from "2013-08-04"
    # to "2013-08-04"
    # at "2013-08-04"
  end
end
