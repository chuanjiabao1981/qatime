module Qawechat
  class WechatVoice < ActiveRecord::Base
    has_one :voice, as: :voicable, class_name: "Media::Voice"
  end
end
