class CustomizedCourseMessageRepliesController < ApplicationController
  include QaMessage
  layout "application"
  respond_to :html

  include QaCommonFilter
  __add_last_operator_to_param(:customized_course_message_reply)

  def create

      @customized_course_message_reply        =
          @customized_course_message.customized_course_message_replies.build(params[:customized_course_message_reply].permit!)

    #如果上传了微信语音消息
    if params[:media_id]
      voice_message = MediaService::Voice::CreateWechatVoiceMessage.new(params[:media_id]).call
      @customized_course_message_reply.messageble = voice_message
    end

    @customized_course_message_reply.author = current_user

    if @customized_course_message_reply.save
      flash[:success] = I18n.t('flash.customized_course_message_reply.create.success')
      respond_with @customized_course_message
      return
    else
      customized_course_message_show_prepare
      render 'customized_course_messages/show'
      return
    end
  end
  def show
    page_num = @customized_course_message.customized_course_message_replies.page_num(@customized_course_message_reply)
    redirect_to customized_course_message_path(@customized_course_message,page: page_num,
                                              customized_course_message_reply_animate: @customized_course_message_reply.id,
                                              anchor: "customized_course_message_reply_#{@customized_course_message_reply.id}")
  end
  private
  def current_resource
    if params[:customized_course_message_id]
      @customized_course_message            = CustomizedCourseMessage.find(params[:customized_course_message_id])
      r                                     = @customized_course_message
    end
    if params[:id]
      @customized_course_message_reply      = CustomizedCourseMessageReply.find(params[:id])
      @customized_course_message            = @customized_course_message_reply.customized_course_message
      r                                     = @customized_course_message_reply
    end
    r
  end
end
