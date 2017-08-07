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
        recharge.remote_order.try(:prepay_id)
      end
      expose :nonce_str do |recharge|
        recharge.remote_order.try(:nonce_str)
      end
      expose :app_pay_params do |recharge|
        recharge.remote_order.try(:app_pay_params)
      end
      expose :app_pay_str do |recharge|
        recharge.remote_order.try(:app_pay_str)
      end
      expose :product_type
      expose :product, using: Entities::LiveStudio::Course, if: { type: :product } do |order|
        order.product if order.product_type == 'LiveStudio::Course'
      end
      expose :product_interactive_course, using: Entities::LiveStudio::InteractiveCourse, if: { type: :product } do |order|
        order.product if order.product_type == 'LiveStudio::InteractiveCourse'
      end
      expose :product_video_course, using: Entities::LiveStudio::VideoCourse, if: { type: :product } do |order|
        order.product if order.product_type == 'LiveStudio::VideoCourse'
      end
      expose :product_customized_group, using: Entities::LiveStudio::Group, if: { type: :product } do |order|
        order.product if order.product_type == 'LiveStudio::Group'
      end
      expose :coupon_code do |c|
        c.coupon.try(:code)
      end
    end
  end
end
