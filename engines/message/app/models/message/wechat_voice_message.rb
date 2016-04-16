module Message
  class WechatVoiceMessage < ActiveRecord::Base
    has_one :message, as: :implementable
  end
end
