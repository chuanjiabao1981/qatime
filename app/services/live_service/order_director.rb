module LiveService
  class OrderDirector
    def initialize(order)
      @order = order
    end

    # 过滤订单
    # 检索条件: cate
    def self.orders_for_user_index(user, params)
      @orders = user.orders.show_orders

      case params[:cate].to_s.to_sym
      when :unpaid
        statuses = Payment::Order::CATE_UNPAID.map{|status| Payment::Order.statuses[status]}
        @orders = @orders.where(status: statuses)
      when :paid
        statuses = Payment::Order::CATE_PAID.map{|status| Payment::Order.statuses[status]}
        @orders = @orders.where(status: statuses)
      when :canceled
        statuses = Payment::Order::CATE_CANCELED.map{|status| Payment::Order.statuses[status]}
        @orders = @orders.where(status: statuses)
      end

      @orders
    end
  end
end
