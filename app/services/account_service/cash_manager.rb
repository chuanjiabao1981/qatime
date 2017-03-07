# 账户模块
module AccountService
  # 账户资金管理
  class CashManager
    def initialize(account)
      @account = account
    end

    # 增加资金
    def increase(type, amount, transaction)
      @account.with_lock do
        @account.balance += amount
        record_detail!(type, amount, amount, transaction)
        @account.save!
        yield if block_given?
      end
    end

    # 减少资金
    def decrease(type, amount, transaction)
      @account.with_lock do
        @account.balance -= amount
        record_detail!(type, amount, -amount, transaction)
        @account.save!
        yield if block_given?
      end
    end

    # 记录账户明细
    def record_detail!(type, amount, different, transaction)
      record = @account.change_records.create(type: type, amount: amount, different: different, transaction: transaction)
      @account.total_income += record.amount if record.is_a?(Payment::EarningRecord) # 如果是收入记录增加总收入
      @account.total_expenditure += record.amount if record.is_a?(Payment::ConsumptionRecord) # 如果是消费记录增加总消费
    end
  end
end
