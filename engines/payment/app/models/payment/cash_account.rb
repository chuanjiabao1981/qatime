module Payment
  # 资金账户
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records
    has_many :recharge_records
    has_many :withdraw_records
    has_many :earning_records
    has_many :consumption_records

    validates :owner, presence: true

    # 充值
    def recharge(amount, target)
      change(:recharge_records, -amount.abs, target, nil, "账户提现")
    end

    # 提现
    def withdraw(amount, target)
      change(:withdraw_records, amount.abs, target, nil, "账户提现")
    end

    # 收入
    def earning(amount, target, billing, summary)
      change(:earning_records, amount.abs, target, billing, summary)
    end

    # 支出
    def consumption(amount, target, billing, summary)
      change(:consumption_records, -amount.abs, target, billing, summary)
    end

    private

    def change(records_chain, amount, target, billing, summary)
      return if amount == 0
      with_lock do
        after = balance + amount
        change_record = send(records_chain).create!(
          before: balance,
          after: after,
          amount: amount,
          different: amount,
          billing: billing,
          summary: summary,
          owner: owner,
          target: target)
        self.balance += change_record.different
        save!
      end
    end
  end
end
