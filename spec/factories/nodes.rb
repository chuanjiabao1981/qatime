# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node do
    sequence(:name){|n| "name#{n}" }
    summary 'summary'
    section
  end
end
