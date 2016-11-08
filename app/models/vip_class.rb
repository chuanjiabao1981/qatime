class VipClass < ApplicationRecord
  has_many :questions
  has_many :learning_plans
end
