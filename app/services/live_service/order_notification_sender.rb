module LiveService
  class OrderNotificationSender
    def initialize(order)
      @order = order
    end

    def notice(action_name)
      receivers_of(action_name).each do |receiver|
        ::PaymentOrderNotification.create(receiver: receiver, notificationable: @order, action_name: action_name)
      end
    end

    private

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    # 订单退款成功通知用户
    def refund_success_receivers_of
      [@order.user]
    end

    # 订单退款审核失败通知用户
    def refund_fail_receivers_of
      [@order.user]
    end

  end
end
