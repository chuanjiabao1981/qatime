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

        oss_file_uri = WechatVoiceConvertWorker.new.perform(media_id)

        wechat_voice = Qawechat::WechatVoice.new
        wechat_voice.name = oss_file_uri
        wechat_voice.save

        voice = wechat_voice.build_voice
        voice.save

        voice_message = Message::VoiceMessage.new
        voice_message.voice = voice
        voice_message.save
        voice_message.reload
        assert_equal voice_message.voice, voice

        voice_message.customized_course_message_reply = @customized_course_message_reply
        voice_message.save
        @customized_course_message_reply.reload
        assert @customized_course_message_reply.messageble.voice.voicable.name, oss_file_uri
      end
    end
  end
end
