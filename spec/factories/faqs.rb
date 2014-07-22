# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faq do
    name "MyString"
    desc "MyText"
    token "MyString"
    user nil
  end
end
