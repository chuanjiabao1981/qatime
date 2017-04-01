module Entities
  class UserInfo < User
    expose :chat_account, using: Entities::LiveStudio::ChatAccount
    expose :openid do |user|
      user.wechat_users.last.try(:openid)
    end
  end
end