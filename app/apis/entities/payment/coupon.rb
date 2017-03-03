module Entities
  module Payment
    class Coupon < Grape::Entity
      expose :id
      expose :code
      expose :price
    end
  end
end
