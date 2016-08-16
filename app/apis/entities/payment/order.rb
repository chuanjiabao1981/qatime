module Entities
  module Payment
    class Order < Grape::Entity
      expose :id do |order|
        order.order_no
      end
      expose :status
      expose :prepay_id
      expose :nonce_str
      expose :app_pay_params
    end
  end
end
