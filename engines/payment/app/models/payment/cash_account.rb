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
      change(:recharge_records, amount.abs, target: target, billing: nil, summary: "账户充值")
    end

    # 提现
    def withdraw(amount, target)
      change(:withdraw_records, -amount.abs, target: target, billing: nil, summary: "账户提现")
    end

    # 收入
    def earning(amount, target, billing, summary)
      change(:earning_records, amount.abs, target: target, billing: billing, summary: summary)
      lock!
      self.total_income += amount.abs
      save!
    end

    # 支出
    def consumption(amount, target, billing, summary, options = {})
      options ||= {}
      change(:consumption_records, -amount.abs, options.merge(target: target, billing: billing, summary: summary))
      lock!
      self.total_expenditure -= amount.abs
      save!
    end

    private

    def change(records_chain, amount, attrs)
      return if amount == 0
      with_lock do
        after = balance + amount
        change_record = send(records_chain).create!(
          attrs.merge(
            before: balance,
            after: after,
            amount: amount,
            different: amount,
            owner: owner))
        self.balance += change_record.different
        save!
      end
    end
  end
end
