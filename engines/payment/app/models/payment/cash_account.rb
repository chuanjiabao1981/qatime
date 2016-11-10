module Payment
  # 资金账户
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records
    has_many :recharge_records
    has_many :withdraw_change_records
    has_many :earning_records
    has_many :consumption_records

    validates :owner, presence: true

    # 可用资金
    def available_balance
      balance - frozen_balance
    end

    # 冻结资金
    def freeze_cash!(amount)
      amount = amount.abs
      Payment::CashAccount.transaction do
        with_lock do
          check_change!(amount)
          self.frozen_balance += amount
          save!
        end
      end
    end

    # 申请提现的时候冻结资金
    def frozen(amount)
      Payment::CashAccount.transaction do
        self.frozen_balance += amount
        save!
      end
    end

    # 取消冻结资金
    def cancel_frozen(amount)
      Payment::CashAccount.transaction do
        self.frozen_balance -= amount
        save!
      end
    end

    # 充值
    def recharge(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:recharge_records, amount.abs, target: target, billing: nil, summary: "账户充值")
        end
      end
    end

    # 提现
    def withdraw(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:withdraw_change_records, -amount.abs, target: target, billing: nil, summary: "账户提现")
          self.frozen_balance -= amount
          save!
        end
      end
    end

    # 收入
    def earning(amount, target, billing, summary)
      Payment::CashAccount.transaction do
        with_lock do
          change(:earning_records, amount.abs, target: target, billing: billing, summary: summary)
          self.total_income += amount.abs
          save!
        end
      end
    end

    # 支出
    def consumption(amount, target, billing, summary, options = {})
      Payment::CashAccount.transaction do
        with_lock do
          check_value!(amount.abs) # 不可透支消费
          change(:consumption_records, -amount.abs, options.merge(target: target, billing: billing, summary: summary))
          self.total_expenditure += amount.abs
          save!
        end
      end
    end

    # 预支消费
    def preconsumption(amount, target, billing, summary, options = {})
      Payment::CashAccount.transaction do
        with_lock do
          change(:consumption_records, -amount.abs, options.merge(target: target, billing: billing, summary: summary))
          self.total_expenditure += amount.abs
          save!
        end
      end
    end

    private

    # 资金变动
    # force可以透支消费
    def change(records_chain, amount, attrs)
      return if amount == 0
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

    def check_value(amount)
      return true unless available_balance < amount
      errors.add(:available_balance, 'not_enough')
      false
    end

    def check_value!(amount)
      raise Payment::BalanceNotEnough unless check_value(amount)
    end
  end
end
