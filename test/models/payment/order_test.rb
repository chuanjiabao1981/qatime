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
  end
end
