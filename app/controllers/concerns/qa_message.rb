module QaMessage
  extend ActiveSupport::Concern


  def customized_course_message_show_prepare
    @customized_course_message_replies =
                        @customized_course_message.customized_course_message_replies.paginate(page: params[:page])
    if @customized_course_message_reply.nil?
      @customized_course_message_reply =
        @customized_course_message.customized_course_message_replies.build
    end
  end
end
