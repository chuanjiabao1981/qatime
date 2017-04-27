module Entities
  module Payment
    class ItunesProduct < Grape::Entity
      expose :id
      expose :product_id
      expose :name
      expose :price
      expose :amount
      expose :online
    end
  end
end
