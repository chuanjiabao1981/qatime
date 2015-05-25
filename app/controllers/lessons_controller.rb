class LessonsController < ApplicationController
  respond_to :html
  layout "application"

  def show
    @lesson     = Lesson.find(params[:id])
    @topics     = Topic.where(lesson_id: @lesson.id)
  end

  def destroy
    @course = @lesson.course
    @lesson.destroy
    redirect_to course_path(@course)
  end
end