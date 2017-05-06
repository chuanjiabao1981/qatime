require 'test_helper'

module LiveServiceTest
  class RefundManagerTest < ActiveSupport::TestCase

    # 退款到外部账户
    test 'refund to external account' do
      @refund = payment_transactions(:refund_to_weixin)
      @student_account = users(:student2).cash_account!
      @system_account = CashAdmin.cash_account!
      assert_difference "Payment::RefundPayRecord.count", 1, "系统销售记录没有生成" do
        assert_difference "Payment::RefundRecord.count", 1, "学生没有生成退款记录" do
          assert_difference "@system_account.reload.balance.to_f", -50, "系统没有正确扣款" do
            assert_no_difference "@student_account.reload.balance.to_f", "重复退款" do
              BusinessService::RefundManager.new(@refund).billing
            end
          end
        end
      end
      assert @refund.reload.submited?, "退款结账后状态不正确"
    end
  end
end
