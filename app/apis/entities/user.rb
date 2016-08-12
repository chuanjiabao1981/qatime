module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :avatar_url
  end
end
