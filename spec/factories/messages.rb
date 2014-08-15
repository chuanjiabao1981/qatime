# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    sender_id 1
    receiver_id 1
    message_type "MyString"
    status "MyString"
    content "MyText"
  end
end
