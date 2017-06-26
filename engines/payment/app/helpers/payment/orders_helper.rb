module Payment
  module OrdersHelper
    def order_operating(order, options = {})
      return nil if order.blank?
      if Payment::Order::CATE_PAID[0, 3].include?(order.status) && order.product.can_refund?
        if ::LiveService::OrderDirector.new(order).try(:remaining_amount).to_f > 0
          link_to('申请退款', payment.refund_user_order_path(order.user, order.transaction_no), options)
        else
          link_to('申请退款', 'javascript:void(0);', class: 'disable')
        end
      elsif order.refunding?
        link_to('取消退款', payment.cancel_refund_user_order_path(order.user, order.transaction_no), options.merge(method: :put))
      end
    end
  end
end
