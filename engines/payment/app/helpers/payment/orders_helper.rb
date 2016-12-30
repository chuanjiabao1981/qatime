module Payment
  module OrdersHelper
    def order_operating(order)
      return nil if order.blank?
      link_to('重新购买', live_studio.new_course_order_path(order.product)) if order.refunded? && order.product.for_sell?
      link_to('申请退款', payment.refund_apply_user_order_path(order.user, order.transaction_no)) if Payment::Order::CATE_PAID.include?(order.status) && order.product.for_sell?
    end
  end
end
