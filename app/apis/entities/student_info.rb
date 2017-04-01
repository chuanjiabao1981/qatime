module Entities
  class StudentInfo < Entities::Student
    expose :chat_account, using: Entities::LiveStudio::ChatAccount
    expose :openid do |user|
      user.wechat_users.last.try(:openid)
    end
  end
end
