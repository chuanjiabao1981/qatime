module MessageService
  class DispatchMessage
    def initialize(current_user_id, options)
      @options = options
      @current_user_id = current_user_id
    end

    def call
      if @options[:message_type] == 'text_message' and @options[:text_message_content].length > 0
        options = {
            type: :text,
            params: {
                content: @options[:text_message_content],
                author_id: @current_user_id
            }
        }
        #上传了图片 图片消息
      elsif @options[:message_type] == 'image_message'
        options = {
            type: :images,
            params: {
                image_ids: @options[:image_ids],
                author_id: @current_user_id
            }
        }

        #语音消息
      elsif @options[:media_id]
        options = {
            type: :wechat_voice,
            params: {
                media_id: @options[:media_id],
                author_id: @current_user_id
            }
        }
      end
      MessageService::CreateMessage.new(options).call
    end
  end
end
