module Entities
  class LoginToken < Grape::Entity
    expose :remember_token
    expose :user, using: Entities::LoginUser
  end
end
