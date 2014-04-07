class LessonsController < ApplicationController
  respond_to :html
  def new
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.build()
    @lesson.init
  end
  def create
    @course = Course.find(params[:course_id])
    @lesson =@course.lessons.build(params[:lesson].permit!)
    @lesson.init
    if @lesson.save
      redirect_to course_path(@course)
    else
      render 'new'
    end
  end
  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
    @lesson.init_video
    @course = @lesson.course
  end
end
