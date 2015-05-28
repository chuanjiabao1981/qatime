class LessonsController < ApplicationController
  respond_to :html
  layout "application"
  include TopicsList

  def show
    @lesson     = Lesson.find(params[:id])
    @course     = @lesson.course
    @topics     = get_topics(@lesson)

  end

  def destroy
    @course = @lesson.course
    @lesson.destroy
    redirect_to course_path(@course)
  end
end