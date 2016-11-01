module Entities
  module Recommend
    class Position < Grape::Entity
      expose :name
      expose :kee
      expose :klass_name
    end
  end
end
