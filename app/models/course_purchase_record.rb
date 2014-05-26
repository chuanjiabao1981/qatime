class CoursePurchaseRecord < ActiveRecord::Base
  belongs_to :student,:counter_cache => true
  belongs_to :course,:counter_cache => true
end
