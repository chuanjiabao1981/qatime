module Qawechat
  class WechatUser < ActiveRecord::Base
    belongs_to :user, class_name:'User'
  end
end
