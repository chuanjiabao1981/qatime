module Entities
  module Payment
    class CashAccount < Grape::Entity
      expose :id
      expose :available_balance, as: :balance
      expose :total_income
      expose :total_expenditure
      expose :password?, as: :has_password
      expose :password_set_at do |c|
        c.password_set_at.to_i
      end
    end
  end
end
