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
    logger.info(@lesson.errors.full_messages)
  end

  def update
    if params[:edit]
      params[:lesson][:state_event] = 'edit'
    elsif params[:submit]
      params[:lesson][:state_event] = 'submit'
    end
    if @lesson.update_attributes(params[:lesson].permit!)
      logger.info(@lesson.state)
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