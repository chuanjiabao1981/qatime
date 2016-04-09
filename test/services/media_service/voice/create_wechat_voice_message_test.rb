require 'test_helper'

module MediaServiceTest
  module VoiceTest

    class CreateWechatVoiceMessageReply < ActiveSupport::TestCase
      def setup
        @customized_course_message        = customized_course_messages(:customized_course_message1)
        @customized_course_message_reply  = customized_course_message_replies(:customized_course_message_reply1)
        assert @customized_course_message_reply.valid?
        super
      end

      test 'create message reply' do
        res = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
        media_id = res['media_id']

        voice_message = MediaService::Voice::CreateWechatVoiceMessage.new(media_id).call
        assert_equal media_id, voice_message.voice.voicable.name
      end
    end

  end
end
