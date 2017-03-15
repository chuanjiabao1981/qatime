# 账户模块
module AccountService
  # 账户资金管理
  class CashManager
    def initialize(account)
      @account = account
    end

    # 增加资金
    def increase(type, amount, business)
      @account.with_lock do
        @account.balance += amount
        record_detail!(type, amount, amount, business)
        @account.save!
        yield if block_given?
      end
    end

    # 减少资金
    def decrease(type, amount, business)
      @account.with_lock do
        @account.balance -= amount
        # 订单支付不可以透支
        raise Payment::BalanceNotEnough, "余额不足" if @account.balance < 0 && business.is_a?(Payment::Order)
        record_detail!(type, amount, -amount, business)
        @account.save!
        yield if block_given?
      end
    end

    # 记录账户明细
    def record_detail!(type, amount, different, business)
      record = @account.change_records.create(type: type, amount: amount, different: different,
                                              business: business, before: @account.balance_was, after: @account.balance_was + different)
      @account.total_income += record.amount if record.is_a?(Payment::EarningRecord) # 如果是收入记录增加总收入
      @account.total_expenditure += record.amount if record.is_a?(Payment::ConsumptionRecord) # 如果是消费记录增加总消费
      @account.save!
    end
  end
end
