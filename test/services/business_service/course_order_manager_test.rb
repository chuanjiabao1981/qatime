require 'test_helper'

module LiveServiceTest
  class CourseOrderManagerTest < ActiveSupport::TestCase
    # 余额支付结账
    test 'account balance order billing' do
      @order = payment_transactions(:account_order)
      @student_account = users(:student1).cash_account!
      @system_account = CashAdmin.cash_account!
      assert_difference "Payment::SellRecord.count", 1, "系统销售记录没有生成" do
        assert_difference "Payment::ConsumptionRecord.count", 1, "学生消费记录没有生成" do
          assert_difference "@system_account.reload.balance.to_f", 30, "系统销售收入不正确" do
            assert_difference "@student_account.reload.balance.to_f", -30, "学生余额扣款不正确" do
              BusinessService::CourseOrderManager.new(@order).billing
            end
          end
        end
      end
      p @order.reload.status
      assert @order.reload.shipped?, "订单结账后状态不正确"
    end

    # 第三方支付结账
    test 'extenal pay order billing' do
      @order = payment_transactions(:alipay_order)
      @student_account = users(:student3).cash_account!
      @system_account = CashAdmin.cash_account!
      assert_difference "Payment::SellRecord.count", 1, "系统销售记录没有生成" do
        assert_difference "Payment::ConsumptionRecord.count", 1, "学生消费记录没有生成" do
          assert_difference "@system_account.reload.balance.to_f", 30, "系统销售收入不正确" do
            assert_no_difference "@student_account.reload.balance.to_f", "学生重复扣款" do
              BusinessService::CourseOrderManager.new(@order).billing
            end
          end
        end
      end
      assert @order.reload.shipped?, "订单结账后状态不正确"
    end
  end
end
