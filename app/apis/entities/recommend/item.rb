module Entities
  module Recommend
    class Item < Grape::Entity
      expose :title
      expose :index
      expose :type
      expose :reason
    end
  end
end
