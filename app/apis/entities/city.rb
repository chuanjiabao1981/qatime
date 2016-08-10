module Entities
  class City < Grape::Entity
    expose :id
    expose :province_id
    expose :name
    expose :schools, using: Entities::School, if: { type: :schools }
  end
end
