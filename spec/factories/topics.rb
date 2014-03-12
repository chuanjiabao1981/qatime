# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    sequence(:title) {|n| "title_#{n}"}
    sequence(:body)  {|n| "body_#{n}" }
    node
    user
  end
end
