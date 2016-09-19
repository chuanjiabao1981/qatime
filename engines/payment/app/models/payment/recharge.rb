module Payment
  class Recharge < Transaction
    extend Enumerize
    include AASM

    attr_accessor :remote_ip, :trade_type

    has_one :remote_order, as: :order, class_name: Payment::WeixinOrder

    enumerize :pay_type, in: { alipay: 0, weixin: 1 }

    enum status: {
           unpaid: 0, # 等待支付
           paid: 1, # 已支付
           shipped: 2, # 已发货
           received: 3, # 已收货,充值成功
           closed: 94, # 已关闭
           canceled: 95, # 已取消
           refunded: 98, # 已退款
         }

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :paid
      state :shipped
      state :received
      state :closed
      state :canceled

      event :pay, after_commit: :deliver! do
        transitions from: :unpaid, to: :paid
      end

      # 充值
      event :deliver do |recharge|
        before do
          change_cash!
        end
        transitions from: [:paid, :shipped], to: :received
      end
    end

    after_save :instance_remote_order, if: :pay_type_changed?
    def instance_remote_order
      return unless pay_type == 'weixin'
      create_remote_order(amount: amount, remote_ip: remote_ip, order_no: transaction_no, trade_type: Payment::WeixinOrder::TRADE_TYPES[source.to_sym])
    end

    def notify_url
      "#{WECHAT_CONFIG['domain_name']}/payment/notify"
    end

    private
    # 充值成功后资金变动
    def change_cash!
      user.cash_account!.increase(amount, nil, "账户充值")
    end

    # 生成流水号
    before_create :generate_transaction_no
    def generate_transaction_no
      self.transaction_no = Util.random_order_no
    end

  end
end
