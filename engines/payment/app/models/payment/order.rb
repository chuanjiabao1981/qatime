module Payment
  class Order < Transaction
    extend Enumerize
    include AASM

    include Payment::Payable
    include Payment::AutoPayable
    # coupon_code 用于优惠券
    # verified_amount 用于校验下单金额是否跟实际支付金额一致, 暂时不使用
    attr_accessor :payment_password, :coupon_code, :verified_amount

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
    CATE_PAID = %w(paid settled shipped completed refunding).freeze
    CATE_CANCELED = %w(canceled refunded).freeze
    CATE_OTHER = %w(expired failed waste).freeze

    # 有效订单
    # 成功支付就算有效订单
    # 增加状态请修改这里
    scope :valid_order, -> { where(status: statuses.slice(:paid, :settled, :shipped, :completed, :refunding, :refunded).values) }

    enum status: {
      unpaid: 0, # 未支付
      paid: 1, # 已支付
      settled: 2, # 已结算
      shipped: 3, # 已发货
      completed: 5, # 已完成
      refunding: 94, # 退款中
      canceled: 95, # 已取消
      expired: 96, # 过期订单
      failed: 97, # 下单失败
      refunded: 98, # 已退款
      waste: 99 # 无效订单
    }

    belongs_to :user
    belongs_to :product, polymorphic: true
    belongs_to :seller, polymorphic: true
    belongs_to :coupon, class_name: "::Payment::Coupon"
    # 代理经销商
    delegate :owner, to: :coupon, allow_nil: true, prefix: true

    validates :user, :product, :pay_type, presence: true

    has_many :billings, as: :target

    validate do |record|
      record.product.validate_order(record) if new_record? && record.product
    end

    validate :coupon_code_valid, on: :create
    def coupon_code_valid
      errors.add(:coupon_code, I18n.t("error.payment/order.coupon_code_invalid")) if coupon_code.present? && !::Payment::Coupon.exists?(code: coupon_code)
    end

    before_validation :set_seller, on: :create
    def set_seller
      self.seller = coupon_owner if coupon_owner
    end

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :paid
      state :canceled
      state :settled
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

      event :settle, after_commit: :ship! do
        transitions from: :paid, to: :settled
      end

      event :ship do
        before do
          delivery_product!
        end
        transitions from: :settled, to: :shipped
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
        transitions from: [:refunding], to: :paid
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
    def delivery_product!
      product.deliver(self)
    end

    # 应该支付金额
    def pay_money
      return 1 if Rails.env.testing? || Rails.env.development?
      (amount * 100).to_i
    end

    # 优惠价格
    def cheap_price
      [product.try(:price).to_f - amount, 0.0].max
    end

    # 销售收入增加额(分成利润)
    def profit_amount
      product.try(:calculate_sell_percentage).presence || 0.0
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

    def show_status_text
      %[paid unpaid].include?(status) ? cate_text : status_text
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

      cate = status if %w[refunding refunded expired failed waste].include?(status)

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
      "购买#{product.model_name.human}: #{product.name}"
    end

    def pay_with_ticket_token!(ticket_token)
      raise Payment::TokenInvalid, "无效token" if account? && !user.cash_account!.validate_ticket_token('pay', ticket_token, self)
      BusinessService::CourseOrderManager.new(self).billing
    end

    # 支付密码为空字符串或者nil都不自动支付
    def pay_with_payment_password!
      BusinessService::CourseOrderManager.new(self).billing if check_payment_password?
    rescue Payment::BalanceNotEnough
      errors.add(:pay_type, I18n.t("error.payment/cash_account.balance_not_enough"))
      false
    end

    def pay_and_ship!
      return if account?
      pay! if remote_order.paid?
      BusinessService::CourseOrderManager.new(self).billing
    end

    def use_coupon(coupon)
      coupon = Coupon.find_by(code: coupon) if coupon.is_a?(String)
      return if coupon.blank?
      self.coupon = coupon
      self.coupon_code = coupon.code
      self.discount_amount = coupon.coupon_amount(amount)
      self.amount = total_amount - discount_amount
    end

    private

    # 当有支付密码字段的时候验证支付密码
    def check_payment_password?
      cash_account = user.cash_account!
      # 支付密码为空
      if payment_password.blank?
        errors.add(:payment_password, I18n.t("error.payment/order.payment_password_blank"))
      # 未设置支付密码
      elsif cash_account.password_set_at.blank?
        errors.add(:payment_password, I18n.t("error.payment/order.payment_password_unset"))
      # 支付密码设置时间过短
      elsif cash_account.password_set_at > 2.hours.ago
        errors.add(:payment_password, I18n.t("error.payment/order.payment_password_young"))
      # 支付密码不正确
      elsif !cash_account.authenticate(payment_password)
        errors.add(:payment_password, I18n.t("error.payment/order.payment_password_invalid"))
      end
      errors.blank?
    end

    # 如果不是余额支付, 则改变remote_order状态为已退款
    def remote_order_refund
      remote_order.refund! unless account?
    end

    # 记录支付时间
    def touch_pay_at
      touch(:pay_at)
    end
  end
end
