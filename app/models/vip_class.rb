class VipClass < ActiveRecord::Base
  has_many :questions
  has_many :learning_plans
end
