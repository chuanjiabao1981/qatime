module MediaService
  module Voice
    class CreateWechatVoiceMessage
      def initialize(media_id)
        @media_id = media_id
      end

      def call
        wechat_voice = Qawechat::WechatVoice.new
        wechat_voice.name = @media_id
        wechat_voice.save
        wechat_voice.in_queue!

        voice = wechat_voice.build_voice
        voice.save

        voice_message = Message::VoiceMessage.new
        voice_message.voice = voice
        voice_message.save
        voice_message.reload
        voice_message.save

        voice_message
      end
    end
  end
end
