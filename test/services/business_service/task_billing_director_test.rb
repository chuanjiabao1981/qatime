require 'test_helper'

module LiveServiceTest
  class TaskBillingDirectorTest < ActiveSupport::TestCase
    # 销售任务完成考核
    test 'test billing a finished task' do
      @workstation = workstations(:workstation_one)
      @cash_account = @workstation.cash_account
      @available_account = @workstation.available_account
      @sale_task = payment_sale_tasks(:task_three)
      assert_no_difference '@cash_account.reload.balance.to_f', '完成任务资金变动不正确' do
        assert_difference '@available_account.reload.balance.to_f', 150, '转为可提现金额不正确' do
          BusinessService::TaskBillingDirector.new(@sale_task).task_billing
        end
      end
      assert @sale_task.reload.closed?, "结账状态不正确"
    end

    # 销售任务未完成考核
    test 'test billing a unfinished task' do
      @workstation = workstations(:workstation_hd)
      @cash_account = @workstation.cash_account
      @available_account = @workstation.available_account
      @admin_account = CashAdmin.cash_account!
      @sale_task = payment_sale_tasks(:task_four)
      assert_difference '@cash_account.reload.balance.to_f', -53.4, '未完成任务扣款不正确' do
        assert_difference '@available_account.reload.balance.to_f', 96.6, '转为可提现金额不正确' do
          assert_difference '@admin_account.reload.balance.to_f', 53.4, '系统收到罚金金额不正确' do
            BusinessService::TaskBillingDirector.new(@sale_task).task_billing
          end
        end
      end
      assert @sale_task.reload.closed?, "结账状态不正确"
    end
  end
end
