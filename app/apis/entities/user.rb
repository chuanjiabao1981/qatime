module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :avatar_url do |user|
      user.avatar_url(:resize_to_fill)
    end
  end
end
