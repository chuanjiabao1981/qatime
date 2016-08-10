module Entities
  class School < Grape::Entity
    expose :id
    expose :city_id
    expose :name
  end
end
