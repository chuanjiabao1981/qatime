module Qawechat
  class WechatUser < ActiveRecord::Base
    serialize :userinfo, JSON
    belongs_to :user, class_name:'User'
  end
end
