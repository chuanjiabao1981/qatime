module Entities
  class UserInfo < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :avatar_url
  end
end