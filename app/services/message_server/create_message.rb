module MessageServer
  class CreateMessage
    def initialize(options)
      @options = options
    end

    def call
      send("create_#{@options[:type]}_message", @options[:params])
    end

    def create_text_message(params)
      text_message = Message::TextMessage.new
      text_message.content = params[:content]
      text_message.author_id = params[:author_id]
      text_message.save

      message = Message::Message.new
      text_message.message = message

      message
    end
  end
end