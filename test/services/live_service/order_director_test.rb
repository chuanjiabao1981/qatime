require 'test_helper'

module LiveServiceTest
  class OrderDirectorTest < ActiveSupport::TestCase
    test 'return different cate orders for user' do
      user = users(:student_with_order2)
      assert_equal 5, user.orders.size

      params = {}
      show_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert_equal 4, show_orders.size, "订单数量显示不正确"

      params = { cate: :unpaid }
      unpaid_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert_equal 1, unpaid_orders.size, "未支付订单数量不正确"
      unpaid_orders.each do |order|
        assert Payment::Order::CATE_UNPAID.include?(order.status)
      end

      params = {cate: :paid}
      paid_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert_equal 2, paid_orders.size, "已支付订单数量不正确"
      paid_orders.each do |order|
        assert Payment::Order::CATE_PAID.include?(order.status)
      end

      params = {cate: :canceled}
      canceled_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert_equal 1, canceled_orders.size, "取消订单数量不正确"
      canceled_orders.each do |order|
        assert Payment::Order::CATE_CANCELED.include?(order.status)
      end
    end

    test 'return consumed_amount' do
      order = payment_transactions(:order_for_refund3)
      assert_equal LiveService::OrderDirector.new(order).consumed_amount, order.product.lesson_price, '没有正确返回已消费金额'
    end
  end
end
