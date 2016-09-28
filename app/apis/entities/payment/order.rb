module Entities
  module Payment
    class Order < Grape::Entity
      expose :id do |order|
        order.transaction_no
      end
      expose :amount
      expose :pay_type
      expose :status
      expose :source
      expose :created_at
      expose :updated_at
      expose :pay_at
      expose :prepay_id do |recharge|
        recharge.remote_order.try(&:prepay_id)
      end
      expose :nonce_str do |recharge|
        recharge.remote_order.try(&:nonce_str)
      end
      expose :app_pay_params do |recharge|
        recharge.remote_order.try(&:app_pay_params)
      end
      expose :product, using: Entities::LiveStudio::Course, if: { type: :product }
    end
  end
end
