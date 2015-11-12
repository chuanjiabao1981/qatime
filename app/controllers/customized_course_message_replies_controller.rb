class CustomizedCourseMessageRepliesController < ApplicationController
  include QaMessage
  layout "application"
  respond_to :html


  def create
    @customized_course_message_reply        =
        @customized_course_message.customized_course_message_replies.build(params[:customized_course_message_reply].permit!)
    @customized_course_message_reply.author = current_user
    if @customized_course_message_reply.save
      flash[:success] = I18n.t('flash.customized_course_message_reply.create.success')
    else
      customized_course_message_show_prepare
      render 'customized_course_messages/show'
    end
    respond_with @customized_course_message
  end

  private
  def current_resource
    if params[:customized_course_message_id]
      @customized_course_message    = CustomizedCourseMessage.find(params[:customized_course_message_id])
      r                             = @customized_course_message
    end
  end
end
