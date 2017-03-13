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
        assert_difference "Payment::WithdrawChangeRecord.count", 1, "提现失败" do
          manager.decrease('Payment::WithdrawChangeRecord', 100, nil)
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
        assert_no_difference "Payment::WithdrawChangeRecord.count", "提现没有回退" do
          assert_raises(StandardError) do
            manager.increase('Payment::WithdrawChangeRecord', 100, nil) do
              raise StandardError, '出错了'
            end
          end
        end
      end
    end

    # 测试销售记录
    test 'sell cash' do
      @account = CashAdmin.cash_account!
      manager = AccountService::CashManager.new(@account)
      # 销售成功
      assert_difference "@account.reload.balance.to_f", 300, "销售收入失败" do
        assert_difference "Payment::SellRecord.count", 1, "销售记录失败" do
          manager.increase('Payment::SellRecord', 300, nil)
        end
      end
    end

    # 消费记录
    test 'consmption cash' do
      @account = payment_cash_accounts(:student3_account)
      manager = AccountService::CashManager.new(@account)
      # 余额支付
      assert_difference "@account.reload.balance.to_f", -40, "消费失败" do
        assert_difference "@account.reload.total_expenditure.to_f", 40, "消费失败" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "消费记录失败" do
            manager.decrease('Payment::ConsumptionRecord', 40, nil)
          end
        end
      end

      # 第三方支付
      assert_no_difference "@account.reload.balance.to_f", "消费失败" do
        assert_difference "@account.reload.total_expenditure.to_f", 40, "消费失败" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "消费记录失败" do
            manager.record_detail!('Payment::ConsumptionRecord', 40, 0, nil)
          end
        end
      end
    end
  end
end
