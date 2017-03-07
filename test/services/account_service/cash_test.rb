require 'test_helper'

module AccountServiceTest
  class CashTest < ActiveSupport::TestCase
    # 充值测试
    test 'recharge cash' do
      @account = payment_cash_accounts(:student_balance_account)
      manager = AccountService::CashManager.new(@account)
      # 充值成功
      assert_difference "@account.reload.balance.to_f", 100, "充值失败" do
        assert_difference "Payment::RechargeRecord.count", 1, "充值失败" do
          manager.increase('Payment::RechargeRecord', 100, nil)
        end
      end

      # 充值失败
      assert_no_difference "@account.reload.balance.to_f", "充值没有回退" do
        assert_no_difference "Payment::RechargeRecord.count", "充值没有回退" do
          assert_raises(StandardError) do
            manager.increase('Payment::RechargeRecord', 100, nil) do
              raise StandardError, '出错了'
            end
          end
        end
      end
    end

    # 提现测试
    test 'withdraw cash' do
      @account = payment_cash_accounts(:teacher_account)
      manager = AccountService::CashManager.new(@account)
      # 提现扣款成功
      assert_difference "@account.reload.balance.to_f", -100, "提现失败" do
        assert_difference "Payment::WithdrawRecord.count", 1, "提现失败" do
          manager.decrease('Payment::WithdrawRecord', 100, nil)
        end
      end

      # 提现退款
      assert_difference "@account.reload.balance.to_f", 100, "提现退款失败" do
        assert_difference "Payment::WithdrawRefundRecord.count", 1, "提现退款失败" do
          manager.increase('Payment::WithdrawRefundRecord', 100, nil)
        end
      end

      # 提现扣款失败
      assert_no_difference "@account.reload.balance.to_f", "提现没有回退" do
        assert_no_difference "Payment::WithdrawRecord.count", "提现没有回退" do
          assert_raises(StandardError) do
            manager.increase('Payment::WithdrawRecord', 100, nil) do
              raise StandardError, '出错了'
            end
          end
        end
      end
    end
  end
end
