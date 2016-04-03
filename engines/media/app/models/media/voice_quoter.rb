module Media
  class VoiceQuoter < ActiveRecord::Base
    belongs_to :voice, class_name: 'Media::Voice', foreign_key: :media_voice_id
    belongs_to :message, class_name: 'Message::VoiceMessage', foreign_key: :message_voice_message_id
  end
end
