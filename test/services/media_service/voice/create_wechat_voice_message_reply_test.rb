require 'test_helper'

module MediaServiceTest
  module VoiceTest
    class CreateWechatVoiceMessageReplyTest < ActiveSupport::TestCase
      def setup
        @customized_course_message        = customized_course_messages(:customized_course_message1)
        @customized_course_message_reply  = customized_course_message_replies(:customized_course_message_reply1)
        assert @customized_course_message_reply.valid?
        super
      end

      test 'create message reply' do
        res = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
        media_id = res['media_id']

        reply = MediaService::Voice::CreateWechatVoiceMessageReply.new(media_id).call
        assert_equal media_id, reply.messageble.voice.voicable.name
      end
    end
  end
end
