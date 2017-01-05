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

    # 已消费金额
    # 学生所购买的课程已结算的费用总额
    def consumed_amount
      student = @order.user
      course = @order.product
      ticket = student.live_studio_buy_tickets.where(course: course).active.last
      return 0 if ticket.blank?
      complete_lesson_ids = Payment::Billing.where(target_id: ticket.got_lesson_ids, target_type: 'LiveStudio::Lesson').map(&:target_id).uniq
      LiveStudio::Lesson.where(id: complete_lesson_ids).map{|lesson| lesson.course.lesson_price}.sum
    end

    def generate_refund
      refund_amount = @order.amount - consumed_amount
      Payment::Refund.new(user: @order.user,amount: refund_amount, pay_type: @order.pay_type,status: :init,
                          product: @order.product, transaction_no: @order.transaction_no)
    end
  end
end
