module Entities
  module Recommend
    class Item < Grape::Entity
      expose :title
      # expose :logo_url
      expose :index
      expose :type
    end
  end
end
