module Payment
  # 账户充值
  class Recharge < Transaction
    extend Enumerize
    include AASM
    include Payment::Payable

    attr_accessor :remote_ip, :trade_type

    validates :pay_type, presence: true
    validates :amount, presence: true, numericality: { greater_than: 0.0 }

    has_one :remote_order, as: :order

    enumerize :pay_type, in: { alipay: 1, weixin: 2, offline: 10, itunes: 11 }

    enum status: {
      unpaid: 0, # 等待支付
      paid: 1, # 已支付
      shipped: 2, # 已发货
      received: 3, # 已收货,充值成功
      closed: 94, # 已关闭
      canceled: 95, # 已取消
      refunded: 98 # 已退款
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
      event :deliver do
        before do
          recharge_cash!
        end
        transitions from: [:paid, :shipped], to: :received
      end
    end

    def notify_url
      "#{$host_name}/payment/transactions/#{transaction_no}/notify"
    end

    def return_url
      "#{$host_name}/payment/transactions/#{transaction_no}/result"
    end

    def pay_and_ship!
      pay!
    end

    # 第三方订单subject
    def subject
      "账户充值"
    end

    private

    # 充值成功后资金变动
    def recharge_cash!
      AccountService::CashManager.new(user.cash_account!).increase('Payment::RechargeRecord', amount, self)
    end
  end
end
