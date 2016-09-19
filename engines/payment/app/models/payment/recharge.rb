module Payment
  class Recharge < Transaction
    extend Enumerize
    include AASM

    has_many :remote_orders, as: :order

    enumerize :pay_type, in: { alipay: 1, weixin: 2 }

    enum status: {
           unpaid: 0, # 未支付
           paid: 1, # 已支付
           shipped: 1, # 已发货
           received: 3, # 确认收货
           closed: 94, # 已取消
           canceled: 95, # 已取消
           expired: 96, # 过期订单
           failed: 97, # 下单失败
           refunded: 98, # 已退款
           waste: 99 # 无效订单
         }

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :paid
      state :shipped
      state :received
      state :canceled
      state :closed

      event :pay, after_commit: :deliver! do
        transitions from: :unpaid, to: :paid
      end

      # 发货
      event :deliver do |recharge|
        before do
          change_cash!
        end
        transitions from: [:paid, :shipped], to: :received
      end
    end

    private
    # 充值成功后资金变动
    def change_cash!
      user.cash_account!.increase(amount, nil, "账户充值")
    end
  end
end
