# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gif do
    caption "MyText"
    upvotes 1
    downvotes 1
    views 1
    ratio 1
  end
end
