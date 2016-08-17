module Entities
  module Payment
    class Order < Grape::Entity
      expose :id do |order|
        order.order_no
      end
      expose :status
      expose :prepayid
      expose :noncestr
    end
  end
end
