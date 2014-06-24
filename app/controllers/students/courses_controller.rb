class Students::CoursesController < ApplicationController
  respond_to :json,:js
  def purchase
    begin
      current_user.purchase_course(params[:id])
    rescue => err
      @err_message = err.to_s
    end
    @course = Course.find(params[:id])
    @lesson = @course.lessons.first
    respond_with @lesson
  end
end