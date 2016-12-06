module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nick_name
    expose :avatar_url do |user,options|
      options[:size] == :info ? user.avatar_url(:ex_big) : user.avatar_url
    end
    expose :ex_big_avatar_url do |user|
      user.avatar_url(:ex_big)
    end
    expose :login_mobile
    expose :email
    expose :chat_account, using: Entities::LiveStudio::ChatAccount
    expose :openid do |user|
      user.wechat_user.try(:openid)
    end
  end
end
