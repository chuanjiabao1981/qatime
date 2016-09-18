module Payment
  class Order < ActiveRecord::Base
    has_soft_delete

    RESULT_SUCCESS = "SUCCESS".freeze

    PAY_TYPE = {
      #alipay: 0,
      weixin: 1
    }.freeze

    CATE_UNPAID =%w(unpaid).freeze
    CATE_PAID =%w(paid shipped completed).freeze
    CATE_CANCELED =%w(canceled expired refunded).freeze

    include AASM

    enum status: {
           unpaid: 0, # 未支付
           paid: 1, # 已支付
           shipped: 2, # 已发货
           completed: 3, # 已完成
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
    has_one :qr_code, as: :qr_codeable
    has_many :remote_orders, as: :order

    validate do |record|
      record.product.validate_order(record) if new_record? && record.product
    end

    aasm :column => :status, :enum => true do
      state :unpaid, :initial => true
      state :paid
      state :canceled
      state :shipped
      state :completed
      state :refunded
      state :waste
      state :failed

      event :pay, after_commit: :touch_pay_at do
        before do
          increase_cash_admin_account
        end
        transitions from: :unpaid, to: :paid
      end

      event :cancel do
        before do
          increase_cash_admin_account
        end
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
        transitions from: [:paid, :shipped, :completed], to: :refunded
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
      pay!
      ship!
    end

    # 应该支付金额
    def pay_money
      return 1 if Rails.env.testing? || Rails.env.development?
      (total_money * 100).to_i
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

    after_create :init_remote_order
    def init_remote_order
      return if Rails.env.test?
      r = WxPay::Service.invoke_unifiedorder(remote_params)
      if r["return_code"] == Payment::Order::RESULT_SUCCESS
        self.pay_url = r['code_url']
        assign_qr_code(r['code_url']) if r['code_url'].is_a?(String)
        self.prepay_id = r['prepay_id']
        self.nonce_str = r['nonce_str']
        save
      else
        logger.error '===== PAYMENT ERROR START ====='
        logger.error r
        logger.error remote_params
        logger.error '===== PAYMENT ERROR END ====='
        fail!
      end
    end

    def init_order_for_test
      raise 'Only For Test' unless Rails.env.test?
      self.pay_url = 'http://localhost/'
      save
      pay_and_ship!
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
        notify_url:  "#{WECHAT_CONFIG['domain_name']}/payment/notify",
        trade_type: trade_type,
        fee_type: 'CNY'
      }
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

    private

    before_create :generate_order_no

    def generate_order_no
      num = '%04d' % rand(1000)
      self.order_no = Time.now.to_s(:number) + num
    end

    # 支付以后cash_admin账户增加金额
    def increase_cash_admin_account
      billing = billings.create(total_money: total_money, summary: "用户支付, 订单编号：#{order_no} 系统进账: #{total_money}")
      CashAdmin.increase_cash_account(total_money, billing, '用户充值消费')
    end

    # 记录支付时间
    def touch_pay_at
      touch(:pay_at)
    end

    def assign_qr_code(url)
      relative_path = QrCode.generate_tmp(url)
      tmp_path = Rails.root.join(relative_path)
      File.open(tmp_path) do |file|
        create_qr_code(code: file)
      end
      File.delete(tmp_path)
    end
  end
end
