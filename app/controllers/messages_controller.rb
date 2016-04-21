class MessagesController < ApplicationController
  layout "application"

  def index
    @customized_course = CustomizedCourse.includes(messages: :implementable).find(params[:customized_course_id])
  end

  def create
    @customized_course = CustomizedCourse.find(params[:customized_course_id])
    options = {}

    #文字消息
    if params[:text_message_content] and params[:text_message_content].length > 0
      options = {
          type: :text,
          params: {
              content: params[:text_message_content],
              author_id: current_user.id
          }
      }
    #上传了图片 图片消息
    elsif params[:image_messages].length > 0
      options = {
          type: :images,
          params: {
              images: params[:image_messages],
              author_id: current_user.id
          }
      }
    end

    message = MessageServer::CreateMessage.new(options).call
    @customized_course.messages << message

    redirect_to customized_course_messaging_index_path(@customized_course)
  end
end
