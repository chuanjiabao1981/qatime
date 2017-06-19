module Payment
  # 优惠码
  class Coupon < ActiveRecord::Base
    # 优惠码发放人
    belongs_to :owner, polymorphic: true

    has_many :orders, class_name: "::Payment::Order", foreign_key: :coupon_id

    has_many :qr_codes

    validates_presence_of :code, :price
    validates :code, uniqueness: true
    validates :code, length: { is: 4 }, numericality: { only_integer: true }

    enum discount_tp: { percent: 0, amount: 1 }

    attr_accessor :total_amount

    # 默认价格 配置固定
    default_value_for :price, GlobalSettings.default_coupon_price.to_f

    # 生成随机码
    def generate_code
      begin
        self.code = SecureRandom.hex(4)
      end while self.class.exists?(code: code)
      code
    end

    # 优惠金额
    def coupon_amount(amount = nil)
      amount ||= total_amount
      # 固定金额优惠
      return after_amount(amount.to_f) if amount?
      discount_amount(amount)
    end

    # 优惠后金额
    def after_amount(amount)
      amount - coupon_amount(amount)
    end

    private

    # 打折优惠金额
    def discount_amount(amount)
      amount * percent
    end

    # 固定金额优惠
    def decrease(amount)
      return 0 if price >= amount
      price.to_f
    end
  end
end
