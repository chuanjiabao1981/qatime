module Entities
  module Payment
    class Recharge < Grape::Entity
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
    end
  end
end
