module Entities
  module Payment
    class Withdraw < Grape::Entity
      expose :transaction_no
      expose :amount
      expose :pay_type
      expose :status
      expose :created_at
      expose :account do |withdraw|
        withdraw.withdraw_record.try(:account)
      end
      expose :name do |withdraw|
        withdraw.withdraw_record.try(:name)
      end
    end
  end
end
