module Entities
  module Payment
    class Refund < Grape::Entity
      expose :id
      expose :transaction_no
      expose :pay_type
      expose :status
      expose :created_at do |refund|
        refund.order.try(:created_at)
      end
      expose :amount do |refund|
        refund.order.try(:amount)
      end
      expose :refund_amount do |refund|
        refund.amount
      end
      expose :reason do |refund|
        refund.refund_reason.try(:reason)
      end
    end
  end
end
