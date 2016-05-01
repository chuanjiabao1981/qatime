module MessageService
  class CreateMessage
    def initialize(options)
      @options = options
    end

    def call
      send("create_#{@options[:type]}_message", @options[:params])
    end

    #创建图片消息
    def create_images_message(params)
      image_message = Message::ImageMessage.new
      image_message.image_ids = params[:image_ids]
      image_message.author_id = params[:author_id]
      image_message.count = image_message.images.length
      message = Message::Message.new
      image_message.message = message
      image_message.save
      
      message
    end

    #创建文字消息
    def create_text_message(params)
      text_message = Message::TextMessage.new
      text_message.content = params[:content]
      text_message.author_id = params[:author_id]
      text_message.save

      message = Message::Message.new
      text_message.message = message

      message
    end

    #创建微信语音消息
    def create_wechat_voice_message(params)
      voice_message = Message::WechatVoiceMessage.new
      voice_message.name = params[:media_id]
      voice_message.author_id = params[:author_id]
      voice_message.save
      voice_message.in_queue!

      message = Message::Message.new
      voice_message.message = message

      message
    end
  end
end
