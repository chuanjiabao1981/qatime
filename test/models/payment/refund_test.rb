require 'test_helper'

module Payment
  class RefundTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test 'belong to order' do
      order = payment_transactions(:order_for_refund2)
      refund = payment_transactions(:refund2)
      assert_equal refund.order, order, '订单错误'
    end

    test 'refund callback' do
      refund = payment_transactions(:refund2)
      admin = users(:admin)
      assert_difference 'refund.user.cash_account.balance', +refund.amount, '未退款至学生账户' do
        refund.allow!(admin)
      end
    end
  end
end
