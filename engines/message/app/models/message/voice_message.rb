module Message
  class VoiceMessage < ActiveRecord::Base
    has_one :customized_course_message_reply, as: :messageble
    has_one :media_voice_quoter, class_name: 'Media::VoiceQuoter', foreign_key: :message_voice_message_id
    has_one :voice, through: :media_voice_quoter, class_name: 'Media::Voice'

    # def voice=(voice)
    #   voice_quoter = Media::VoiceQuoter.new
    #   voice_quoter.voice = voice
    #   debugger
    # end
  end
end
