class Order < ActiveRecord::Base
  PAY_TYPE = {
    alipay: 0
  }.freeze

  belongs_to :user
  belongs_to :product, polymorphic: true

  validates :user, :product, presence: true

  validate do |record|
    record.product.validate_order(record) if record.product
  end

  include AASM

  enum state: {
         unpaid: 0, # 未支付
         paid: 1, # 已支付
         shipped: 2, # 已发货
         completed: 3, # 已完成
         refunded: 98, # 已退款
         waste: 99 # 无效订单
       }

  aasm :column => :state, :enum => true do
    state :unpaid, :initial => true
    state :paid
    state :shipped
    state :completed
    state :refunded
    state :waste

    event :pay do
      transitions from: :unpaid, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped, before: :delivery_product
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

  class << self
    # i18n PAY_TYPE
    def pay_types
      PAY_TYPE.map{|k,v| [I18n.t(k), v]}
    end
  end
end
