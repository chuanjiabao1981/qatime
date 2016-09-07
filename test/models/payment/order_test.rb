require 'test_helper'

module Payment
  class OrderTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

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
      unpid_order = payment_orders(:order_one)
      assert unpid_order.cate_text == "等待付款"

      paid_order = payment_orders(:order2)
      assert paid_order.cate_text == "正在交易"

      canceled_order = payment_orders(:order4)
      assert canceled_order.cate_text == "交易关闭"

      completed_order = payment_orders(:order6)
      assert completed_order.cate_text == "交易完成"
    end
  end
end
