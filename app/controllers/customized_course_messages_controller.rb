class CustomizedCourseMessagesController < ApplicationController
  layout "application"

  def new
    @customized_course_message = @customized_course_message_board.customized_course_messages.build
  end

  private
  def current_resource
    if params[:customized_course_message_board_id]
      @customized_course_message_board = CustomizedCourseMessageBoard.find(params[:customized_course_message_board_id])
    end
  end
end
