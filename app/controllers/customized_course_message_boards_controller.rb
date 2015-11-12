class CustomizedCourseMessageBoardsController < ApplicationController
  layout "application"

  def show

  end

  private
  def current_resource
    if params[:id]
      @customized_course_message_board = CustomizedCourseMessageBoard.find(params[:id])
    end
  end
end
