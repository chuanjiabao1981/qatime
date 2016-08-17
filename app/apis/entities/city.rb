module Entities
  class City < Grape::Entity
    expose :id
    expose :province_id
    expose :name
  end
end
