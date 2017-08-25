module Entities
  module Resource
    class File < Grape::Entity
      expose :id
      expose :name
    end
  end
end
