module Entities
  class City < Grape::Entity
    expose :id
    expose :province_id
    expose :name
    expose :workstations_count
  end
end
