class MessagesController < ApplicationController
  layout "application"

  def index
    @customized_course = CustomizedCourse.includes(messages: :implementable).find(params[:customized_course_id])
  end

  def create
    @customized_course = CustomizedCourse.find(params[:customized_course_id])

    options = {}
    #文字消息
    if params[:text_message_content]
      options = {
          type: :text,
          params: {
              content: params[:text_message_content],
              author_id: current_user.id
          }
      }
    end

    message = MessageServer::CreateMessage.new(options).call
    @customized_course.messages << message
    redirect_to :index
  end
end
