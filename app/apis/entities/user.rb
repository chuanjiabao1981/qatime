module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :small_avatar_url do |u|
      u.avatar_url(:small)
    end
  end
end
