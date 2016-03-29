module Qawechat
  class WechatVoice < ActiveRecord::Base
    has_one :voice, as: :voicable
  end
end
