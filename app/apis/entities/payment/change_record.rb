module Entities
  module Payment
    class ChangeRecord < Grape::Entity
      expose :id
      expose :amount
      expose :change_type
      expose :created_at
    end
  end
end
