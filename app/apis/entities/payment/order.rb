module Entities
  module Payment
    class Order < Grape::Entity
      expose :id do |order|
        order.order_no
      end
      expose :status
      expose :prepay_id
      expose :nonce_str
      expose :generate_app_pay_params do |order|
        WxPay::Service.generate_app_pay_req(order.remote_params)
      end
    end
  end
end
