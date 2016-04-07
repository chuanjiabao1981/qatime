module MediaService
  module Voice
    class CreateWechatVoiceMessageReply
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

        reply = CustomizedCourseMessageReply.new
        reply.messageble = voice_message
        reply
      end
    end
  end
end
