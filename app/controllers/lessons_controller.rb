class LessonsController < ApplicationController
  respond_to :html
  def new
    @course = Course.find(params[:course_id])
    @lesson = @course.build_lesson
  end
  def create
    @course = Course.find(params[:course_id])
    @lesson =@course.build_lesson(params[:lesson].permit!)
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
    @lesson.build_a_video
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(params[:lesson].permit!)
      redirect_to course_path(@lesson.course)
    else
      render 'edit'
    end
  end
end
