module Payment
  class Recharge < Transaction
    extend Enumerize

    has_many :remote_orders, as: :order

    enumerize :pay_type, in: { alipay: 1, weixin: 2 }
  end
end
