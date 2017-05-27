module Entities
  module Qawechat
    class WechatUser < Grape::Entity
      expose :id
      expose :openid
      expose :nickname
    end
  end
end
