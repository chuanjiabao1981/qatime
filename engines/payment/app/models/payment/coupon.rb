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

    # 默认价格 配置固定
    default_value_for :price, GlobalSettings.default_coupon_price.to_f

    # 生成随机码
    def generate_code
      begin
        self.code = SecureRandom.hex(4)
      end while self.class.exists?(code: self.code)
      self.code
    end

  end
end
