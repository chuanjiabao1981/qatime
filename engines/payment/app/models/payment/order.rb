module Payment
  class Order < ActiveRecord::Base
    has_soft_delete

    PAY_TYPE = {
      #alipay: 0,
      weixin: 1
    }.freeze

    include AASM

    enum status: {
           unpaid: 0, # 未支付
           paid: 1, # 已支付
           shipped: 2, # 已发货
           completed: 3, # 已完成
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

    aasm :column => :status, :enum => true do
      state :unpaid, :initial => true
      state :paid
      state :shipped
      state :completed
      state :refunded
      state :waste

      event :pay do
        before do
          increase_cash_admin_account
        end
        transitions from: :unpaid, to: :paid
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



    class << self
      # i18n PAY_TYPE
      def pay_types
        PAY_TYPE.map{|k,v| [I18n.t("activerecord.view.#{k}"), v]}
      end
    end

    after_create :init_remote_order
    def init_remote_order
      r = WxPay::Service.invoke_unifiedorder(remote_params)
      if r['code_url'].blank?
        fail!
      else
        self.pay_url = r['code_url']
        self.qrcode_url = Qr_Code.generate_payment(id, r['code_url'])
        save
      end
    end

    # 支付是否超时微信两小时过期
    def pay_timeout?
      return false unless unpaid?
      created_at > 2.hours.ago
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

    def remote_params
      {
          body: "购买辅导班：#{product.name}",
          out_trade_no: order_no,
          total_fee: pay_money,
          spbill_create_ip: remote_ip,
          notify_url:  "#{WECHAT_CONFIG['domain_name']}/payment/notify",
          trade_type: 'NATIVE',
          fee_type: 'CNY'
      }
    end
  end
end
