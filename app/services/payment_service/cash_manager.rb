module PaymentService
  class CashManager
    def initialize(account)
      @account = account
    end

    # 收入
    def earning(amount, billing, billing_item)
      _account_lock_process do
        @account.balance += amount # 总余额
        @account.total_income += amount
        # 工作站账户收入不可提现
        # 其它账户收入可立即提现
        @account.is_a?(Workstation) ? _unavailable_earning(amount) : _available_earning(amount)
        _change_records(@account.earning_reacords, amount, billing: billing, billing_item: billing_item)
        @account.save!
      end
    end

    # 系统分账支出
    def split_pay(amount, billing, billing_item)
      admin_required!
      _account_lock_process do
        @account.balance -= amount # 总余额
        @account.unavailable_balance -= amount # 不可提现金额
        _change_records(@account.split_pay_reacords, -amount, billing: billing, billing_item: billing_item)
      end
    end

    # 代收费用
    def advance_charge(amount, billing)
      admin_required!
      _account_lock_process do
        @account.balance += amount # 总余额
        @account.unavailable_balance += amount # 不可提现金额
        _change_records(@account.advance_charge_reacords, amount, billing: billing)
      end
    end

    # 消费
    # consumption_method 消费方式  account: 余额消费
    def consumption(amount, billing, consumption_method)
      _account_lock_process do
        @account.total_expenditure += amount
        # 余额消费需要扣款
        # 第三方支付消费只生成消费记录，不扣款
        if 'account' == consumption_method
          @account.balance -= amount # 总余额
          @account.available_balance -= amount # 不可提现金额
          _change_records(@account.advance_charge_reacords, amount, billing: billing, different: 0)
        else
          _change_records(@account.advance_charge_reacords, amount, billing: billing)
        end
      end
    end

    private

    # 不可提现收入
    def _unavailable_earning(amount)
      @account.unavailable_balance += amount # 可用余额
    end

    # 可提现收入
    def _available_earning(amount)
      @account.available_balance += amount # 可用余额
    end

    def _account_lock_process(&blk)
      @account.with_lock do
        yield blk if block_given?
        @account.save!
      end
    end

    # 生成资金流水
    # 为了能正确计算流水前后余额，请先进行账户变动，后生成记录
    def _change_records(chain, amount, options = {})
      options = { amount: amount, different: amount }.merge(options)
      options[:target] = options[:billing].target if options[:billing].present?
      options[:summary] = (options[:billing_item] || options[:billing]).try(:summary)
      chain.create!(@account.balance_attrs.merge(options))
    end

    def admin_required!
      raise Payment::InvalidOperation, "该操作仅限于系统账户" unless @account.owner.is_a?(CashAdmin)
    end
  end
end
