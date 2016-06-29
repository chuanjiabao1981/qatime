module Payment
  class Order < ActiveRecord::Base
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
           refunded: 98, # 已退款
           waste: 99 # 无效订单
         }

    belongs_to :user
    belongs_to :product, polymorphic: true

    validates :user, :product, presence: true

    validate do |record|
      record.product.validate_order(record) if record.product
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

    private

    before_create :generate_order_no

    def generate_order_no
      num = '%04d' % rand(1000)
      self.order_no = Time.now.to_s(:number) + num
    end

    # 支付以后cash_admin账户增加金额
    def increase_cash_admin_account
      CashAdmin.increase_cash_account(total_money, self, '用户充值消费')
    end

  end
end
