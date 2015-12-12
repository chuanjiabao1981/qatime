class CustomizedCourseMessageBoardsController < ApplicationController
  layout "application"

  def show
    @customized_course_messages = @customized_course_message_board.customized_course_messages.paginate(page: params[:page])
  end

  private
  def current_resource
    if params[:id]
      @customized_course_message_board = CustomizedCourseMessageBoard.find(params[:id])
    end
  end
end
