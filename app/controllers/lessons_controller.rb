class LessonsController < ApplicationController
  respond_to :html
  def show
    @lesson = Lesson.find(params[:id])
  end

  def destroy
    @course = @lesson.course
    @lesson.destroy
    redirect_to course_path(@course)
  end
end