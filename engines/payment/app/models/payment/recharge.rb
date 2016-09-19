module Payment
  class Recharge < Transaction
    extend Enumerize
    include AASM

    attr_accessor :remote_ip, :trade_type
    has_one :order, as: :product

    enumerize :pay_type, in: { alipay: 0, weixin: 1 }

    enum status: {
           unpaid: 0, # 等待支付
           success: 1, # 充值成功
           closed: 94, # 已关闭
           canceled: 95, # 已取消
           refunded: 98, # 已退款
         }

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :success
      state :closed
      state :canceled

      # 充值
      event :call do |recharge|
        before do
          change_cash!
        end
        transitions from: [:unpaid], to: :success
      end
    end

    # 发货
    def deliver(order)
      return false if order.total_money != amount || !order.paid?
      call!
    end

    def validate_order(_order)
      unpaid?
    end

    # 生成订单
    after_create :instance_order, on: :create
    def instance_order
      o = Order.create(order_params)
      p o.errors
    end

    def name
      self.class.model_name.human
    end

    private
    # 充值成功后资金变动
    def change_cash!
      user.cash_account!.increase(amount, nil, "账户充值")
    end

    def order_params
      { total_money: amount, product: self, pay_type: pay_type, remote_ip: remote_ip, trade_type: trade_type, user: user }
    end

  end
end
