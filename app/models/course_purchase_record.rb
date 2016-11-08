class CoursePurchaseRecord < ApplicationRecord
  belongs_to :student,:counter_cache => true
  belongs_to :course,:counter_cache =>  true
end
