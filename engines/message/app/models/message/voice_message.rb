module Message
  class VoiceMessage < ActiveRecord::Base
    has_one :customized_course_message_reply, as: :messageble
  end
end
