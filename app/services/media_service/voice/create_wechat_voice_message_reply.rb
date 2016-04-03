module MediaService
  module Voice
    class CreateWechatVoiceMessageReply
      def initialize(media_id)
        @media_id = media_id
      end

      def call
        oss_file_uri = WechatVoiceConvertWorker.new.perform(@media_id)

        wechat_voice = Qawechat::WechatVoice.new
        wechat_voice.name = oss_file_uri
        wechat_voice.save

        voice = wechat_voice.build_voice
        voice.save

        voice_message = Message::VoiceMessage.new
        voice_message.voice = voice
        voice_message.save
        voice_message.reload
        voice_message.save

        voice_message.build_customized_course_message_reply
      end
    end
  end
end
