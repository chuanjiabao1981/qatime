module Payment
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records

    validates :owner, presence: true

    # 加钱
    def increase(money, ref, summary)
      change(money, ref, summary)
    end

    # 减钱
    def decrease(money, ref, summary)
      change(-money, ref, summary)
    end

    def change(money, ref, summary)
      change_records.create(before: balance, after: balance + money, different: money, ref: ref, summary: summary)
      self.balance = change_records.sum(:different)
      save
    end
  end
end
