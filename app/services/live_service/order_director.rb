module LiveService
  class OrderDirector
    def initialize(order)
      @order = order
      @product = @order.product
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

    # 已消费金额
    # 学生所购买的课程已结算的费用总额
    def consumed_amount
      @order.amount - remaining_amount
    end

    # 未消费金额
    def remaining_amount
      return 0 unless @order.paid? || @order.shipped? || @order.completed?
      amount = unstart_lesson_ids.count * ticket.lesson_price
      [amount, @order.amount].min
    rescue
      0
    end

    def refund!
      refund = generate_refund
      Payment::Refund.transaction do
        ticket.ticket_items.where(target_id: unstart_lesson_ids).map(&:refund!)
        refund.save
      end
      refund
    end

    def generate_refund
      Payment::Refund.new(user: @order.user, amount: remaining_amount, pay_type: @order.pay_type,
                          product: @order.product, transaction_no: @order.transaction_no, source: @order.source)
    end

    private

    def ticket
      @ticket ||= @product.buy_tickets.find_by(payment_order_id: @order.id)
    end

    def product
      @product ||= @order.product
    end

    def unstart_lesson_ids
      @unstart_lesson_ids ||= product.lessons.unstart.map(&:id)
    end
  end
end
