module Entities
  module Payment
    class Coupon < Grape::Entity
      expose :id
      expose :code
      expose :price
      expose :total_amount
      expose :coupon_amount
    end
  end
end
