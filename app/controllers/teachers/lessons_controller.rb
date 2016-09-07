class Teachers::LessonsController < ApplicationController
  respond_to :html
  layout "application"

  include QaFilesHelper

  def new
    @lesson = @course.build_lesson
  end

  def create
    if params[:edit]
      params[:lesson][:state_event] = 'edit'
    elsif params[:submit]
      params[:lesson][:state_event] = 'submit'
    end
    @lesson =@course.build_lesson(change_params_for_qa_files(params[:lesson]).permit!)
    if @lesson.save
      redirect_to course_path(@course,lesson_id:@lesson.id)
    else
      render 'new'
    end
  end
  def edit
    # @lesson.build_video unless @lesson.video
  end

  def update
    if params[:edit]
      params[:lesson][:state_event] = 'edit'
    elsif params[:submit]
      params[:lesson][:state_event] = 'submit'
    end
    if @lesson.update_attributes(change_params_for_qa_files(params[:lesson]).permit!)
      redirect_to course_path(@lesson.course,lesson_id:@lesson.id)
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

  #private

  #def lesson_params
  #  params.require(:lesson).permit(:name, :desc, :token, :tags, qa_files_attributes: [:name])
  #end
end
