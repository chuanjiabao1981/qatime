require 'test_helper'

module LiveServiceTest
  class TemplateTest  < ActiveSupport::TestCase
    test 'return different cate orders for user' do
      user = users(:student_with_order2)
      assert user.orders.size == 4

      params = {}
      show_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert show_orders.size == 3

      params = {cate: :unpaid}
      unpaid_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert unpaid_orders.size == 1
      unpaid_orders.each do |order|
        assert Payment::Order::CATE_UNPAID.include?(order.status)
      end

      params = {cate: :paid}
      paid_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert paid_orders.size == 1
      paid_orders.each do |order|
        assert Payment::Order::CATE_PAID.include?(order.status)
      end

      params = {cate: :canceled}
      canceled_orders = LiveService::OrderDirector.orders_for_user_index(user, params)
      assert canceled_orders.size == 1
      canceled_orders.each do |order|
       assert Payment::Order::CATE_CANCELED.include?(order.status)
      end
    end
  end
end
