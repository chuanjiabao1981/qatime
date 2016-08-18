module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :avatar_url
    expose :login_mobile
    expose :email
    expose :chat_account, using: Entities::LiveStudio::ChatAccount
  end
end
