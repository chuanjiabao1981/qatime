require 'test_helper'

module AccountServiceTest
  class CashTest < ActiveSupport::TestCase
    # 充值测试
    test 'recharge cash' do
      @account = payment_cash_accounts(:student_balance_account)
      manager = AccountService::CashManager.new(account)
      # 充值成功
      assert_difference "@account.reload.balance.to_f", 100, "充值失败" do
        assert_difference "Payment::RechargeRecord.count", 1, "充值失败" do
          manager.increase('Payment::Recharge', 100, nil)
        end
      end

      # 充值失败
      assert_no_difference "@account.reload.balance.to_f", "充值没有回退" do
        assert_no_difference "Payment::RechargeRecord.count", "充值没有回退" do
          manager.increase('Payment::Recharge', 100, nil) do
            raise StandarError, '出错了'
          end
        end
      end
    end
  end
end
