class Teachers::LessonsController < ApplicationController
  respond_to :html
  def new
    @lesson = @course.build_lesson
  end
  def create
    @lesson =@course.build_lesson(params[:lesson].permit!)
    if @lesson.save
      redirect_to course_path(@course)
    else
      render 'new'
    end
  end
  def edit
    @lesson.build_a_video
  end

  def update
    if @lesson.update_attributes(params[:lesson].permit!)
      redirect_to course_path(@lesson.course)
    else
      render 'edit'
    end
  end

  def destroy
      @course = @lesson.course
      if @lesson.destroy
        redirect_to course_path(@course)
      else
        redirect_to course_path(@course)
      end
  end

  private

  def current_resource
    if params[:id]
      @lesson   = Lesson.find(params[:id])
      @course   = @lesson.course
      @lesson
    elsif params[:course_id]
      @course = Course.find(params[:course_id])
    end
  end
end
