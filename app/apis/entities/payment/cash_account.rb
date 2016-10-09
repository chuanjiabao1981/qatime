module Entities
  module Payment
    class CashAccount < Grape::Entity
      expose :id
      expose :balance
      expose :total_income
      expose :total_expenditure
    end
  end
end
