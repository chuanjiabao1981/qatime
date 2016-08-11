module Entities
  class Province < Grape::Entity
    expose :id
    expose :name
    expose :cities, using: Entities::City, if: { type: :full }
  end
end
