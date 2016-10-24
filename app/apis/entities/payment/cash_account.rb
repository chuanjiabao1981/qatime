module Entities
  module Payment
    class CashAccount < Grape::Entity
      expose :id
      expose :balance do |ca|
        ca.available_balance
      end
      expose :total_income
      expose :total_expenditure
    end
  end
end
