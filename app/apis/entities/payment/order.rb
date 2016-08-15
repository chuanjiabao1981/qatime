module Entities
  module Payment
    class Order < Grape::Entity
      expose :id do |order|
        order.order_no
      end
      expose :status
      expose :prepay_id
      expose :nonce_str
      expose :partner_id do |order|
        WECHAT_CONFIG['mch_id']
      end
      expose :timestamp do |order|
        Time.now.to_i.to_s
      end
    end
  end
end
