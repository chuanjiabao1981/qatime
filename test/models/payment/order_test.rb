require 'test_helper'

module Payment
  class OrderTest < ActiveSupport::TestCase
    test "show orders" do
      user = users(:student_with_order2)
      show_orders = user.orders.show_orders

      show_orders.each do |order|
        assert (
                  Payment::Order::CATE_UNPAID.include?(order.status) ||
                  Payment::Order::CATE_PAID.include?(order.status) ||
                  Payment::Order::CATE_CANCELED.include?(order.status)
                )
      end
    end

    test "cate text" do
      unpid_order = payment_transactions(:order_one)
      assert_equal "等待付款", unpid_order.cate_text, "未付款订单显示不正确"

      paid_order = payment_transactions(:order2)
      assert_equal "交易完成", paid_order.cate_text, "交易订单显示不正确"

      canceled_order = payment_transactions(:order4)
      assert_equal "交易关闭", canceled_order.cate_text, "关闭订单显示不正确"

      completed_order = payment_transactions(:order6)
      assert_equal "订单是无效订单", completed_order.cate_text, "无效订单状态显示不正确"
    end
  end
end
