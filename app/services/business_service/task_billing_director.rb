module BusinessService
  # 销售考核
  class TaskBillingDirector
    def initialize(task)
      @task = task
      @workstation = @task.target
    end

    # 考核结算
    def task_billing
      # 销售额
      @task.with_lock do
        @task.report
        b = Payment::SaleTaskBilling.create(target: @task)
        @task.uncheck_earning_records.update_all(assess_billing_id: b.id)
        b.total_money = @task.income_for_assess_billing(b.id)
        b.save
        charge_item!(b)
        available_item!(b)
        @task.close!
      end
    rescue StandardError => e
      p e
    end

    def self.handle_tasks
      # 开始考核
      Payment::SaleTask.unstart.where('started_at < ?', Time.now).map(&:start!)
      # 开始考核
      Payment::SaleTask.ongoing.where('ended_at < ?', Time.now).each do |task|
        BusinessService::TaskBillingDirector.new(task).task_billing
      end
    end

    private

    # 罚金转账
    def charge_item!(b)
      item = Payment::TaskChargetItem.create!(billing: b,
                                              cash_account: @workstation.cash_account,
                                              owner: @workstation,
                                              amount: @task.charge_balance)
      _cash_transfer(@workstation.cash_account, item.amount, item)
    end

    # 可提现变动
    def available_item!(b)
      item = Payment::TaskAvailableItem.create!(billing: b,
                                                cash_account: @workstation.available_account,
                                                owner: @workstation,
                                                amount: b.total_money - @task.charge_balance)
      _available_transafer(@workstation.available_account, item.amount, item)
    end

    # 资金变动
    def _cash_transfer(from_account, amount, item)
      # 系统收入
      AccountService::CashManager.new(CashAdmin.cash_account!).increase('Payment::SaleTaskRecord', amount, item)
      # 罚金支出
      AccountService::CashManager.new(from_account).decrease('Payment::SaleTaskPayRecord', amount, item)
    end

    # 可提现资金变动
    def _available_transafer(available_account, amount, item)
      AccountService::CashManager.new(available_account).increase('Payment::EarningRecord', amount, item)
    end
  end
end
