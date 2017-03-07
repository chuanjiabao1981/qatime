module Payment
  # 账单项
  class BillingItem < ActiveRecord::Base
    belongs_to :billing
    belongs_to :owner, polymorphic: true
    belongs_to :cash_account

    belongs_to :parent, class_name: BillingItem
    has_many :items, class_name: BillingItem, foreign_key: "parent_id"

    # 账单摘要, 默认为空
    def summary
    end
  end
end
