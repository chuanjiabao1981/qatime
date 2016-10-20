module Entities
  module Payment
    class Withdraw < Grape::Entity
      expose :amount
      expose :pay_type
      expose :status
      expose :account do |withdraw|
        withdraw.withdraw_record.account
      end
      expose :name do |withdraw|
        withdraw.withdraw_record.name
      end
    end
  end
end
