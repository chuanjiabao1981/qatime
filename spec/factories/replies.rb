# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reply do
    sequence(:body)  {|n| "body_#{n}" }
    user
    topic
  end
end