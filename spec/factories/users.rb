FactoryGirl.define do
  factory :user do
    #sequence(:name)   {|n| "name#{n}" }
    sequence(:email)  {|n| "name#{n}@taobao.com"}
    password 'password'
    password_confirmation 'password'
  end
end
