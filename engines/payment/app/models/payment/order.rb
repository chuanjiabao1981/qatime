module Payment
  class Order < Transaction
    extend Enumerize
    include AASM

    include Payment::Payable
    include Payment::AutoPayable
    attr_accessor :payment_password

    RESULT_SUCCESS = "SUCCESS".freeze

    PAY_TYPE = {
      # alipay: 0,
      weixin: 1
    }.freeze

    enumerize :pay_type,
              predicates: true,
              in: {
                account: 0, # 余额支付
                alipay: 1,
                weixin: 2
              }

    CATE_UNPAID = %w(unpaid).freeze
    CATE_PAID = %w(paid shipped completed refunding).freeze
    CATE_CANCELED = %w(canceled expired refunded).freeze

    enum status: {
      unpaid: 0, # 未支付
      paid: 1, # 已支付
      shipped: 2, # 已发货
      completed: 3, # 已完成
      refunding: 94, # 退款中
      canceled: 95, # 已取消
      expired: 96, # 过期订单
      failed: 97, # 下单失败
      refunded: 98, # 已退款
      waste: 99 # 无效订单
    }

    belongs_to :user
    belongs_to :product, polymorphic: true

    validates :user, :product, presence: true

    has_many :billings, as: :target

    validate do |record|
      record.product.validate_order(record) if new_record? && record.product
    end

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :paid
      state :canceled
      state :shipped
      state :completed
      state :refunding
      state :refunded
      state :waste
      state :failed

      event :pay, after_commit: :touch_pay_at do
        transitions from: :unpaid, to: :paid
      end

      event :cancel do
        transitions from: :unpaid, to: :canceled
      end

      event :ship do
        before do
          delivery_product
        end
        transitions from: :paid, to: :shipped
      end

      event :finish do
        transitions from: :shipped, to: :completed
      end

      event :refund do
        transitions from: [:paid, :shipped, :completed], to: :refunding
      end

      event :allow_refund, after: :remote_order_refund do
        transitions from: [:refunding], to: :refunded
      end

      event :refuse_refund do
        transitions from: [:refunding], to: :completed
      end

      event :trash do
        transitions from: [:unpaid], to: :waste
      end

      event :fail do
        error do
          nil
        end
        transitions from: [:unpaid], to: :failed
      end
    end

    # 发货
    def delivery_product
      product.deliver(self)
    end

    # 支付并发货
    def pay_and_ship!
      Payment::Order.transaction do
        order_billing!
        pay!
      end
      ship!
    end

    # 应该支付金额
    def pay_money
      return 1 if Rails.env.testing? || Rails.env.development?
      (amount * 100).to_i
    end

    # 订单状态
    def status_text
      I18n.t("activerecord.status.order.#{status}")
    end

    class << self
      # i18n PAY_TYPE
      def pay_types
        PAY_TYPE.map{|k,v| [I18n.t("activerecord.view.#{k}"), v]}
      end
    end

    def init_order_for_test
      raise 'Only For Test' unless Rails.env.test?
    end

    # 支付是否超时微信两小时过期
    def pay_timeout?
      return false unless unpaid?
      created_at < 2.hours.ago
    end

    def remote_params
      {
        body: "购买辅导班：#{product.name}",
        out_trade_no: order_no,
        total_fee: pay_money,
        spbill_create_ip: remote_ip,
        notify_url:  "#{WECHAT_CONFIG['host']}/payment/notify",
        trade_type: trade_type,
        fee_type: 'CNY'
      }
    end

    def order_no
      transaction_no
    end

    def app_pay_params
      WxPay::Service.generate_app_pay_req(prepayid: prepay_id, noncestr: nonce_str)
    end

    def self.show_orders
      status_waste = Payment::Order.statuses[:waste]
      statuses_failed = Payment::Order.statuses[:failed]
      where.not(status: [status_waste, statuses_failed])
    end

    def cate_text
      cate = if CATE_UNPAID.include?(status)
        'unpaid'
      elsif CATE_PAID.include?(status)
        'paid'
      elsif CATE_CANCELED.include?(status)
        'canceled'
      else
        'others'
      end

      if completed?
        I18n.t("activerecord.cate_text.order.completed")
      else
        I18n.t("activerecord.cate_text.order.#{cate}")
      end
    end

    # 支付通知地址
    def notify_url
      "#{$host_name}/payment/transactions/#{transaction_no}/notify"
    end

    # 支付通知地址
    def return_url
      "#{$host_name}/payment/transactions/#{transaction_no}/result"
    end

    # 第三方订单subject
    def subject
      product.name
    end

    private

    # 如果不是余额支付, 则改变remote_order状态为已退款
    def remote_order_refund
      remote_order.refund! unless account?
    end

    # 记录支付时间
    def touch_pay_at
      touch(:pay_at)
    end

    def order_billing!
      summary = "订单支付, 订单编号：#{order_no} 订单金额: #{amount}"
      billing = billings.create(total_money: amount, summary: summary)
      user.cash_account!.consumption(amount, self, billing, summary, change_type: pay_type)
      CashAdmin.increase_cash_account(amount, billing, summary)
    end

    def auto_paid!
      return unless pay_type.account?
      pay_and_ship!
    rescue => e
      p e
      fail!
    end
  end
end
