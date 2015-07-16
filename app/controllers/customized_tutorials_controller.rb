class CustomizedTutorialsController < ApplicationController
  layout "application"
  respond_to :html

  def index
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :asc)
  end

  def new
    @customized_tutorial = @customized_course.customized_tutorials.build
  end

  def create
    @customized_tutorial = @customized_course.customized_tutorials.build(params[:customized_tutorial].permit!)
    @customized_tutorial.teacher_id = current_user.id
    @customized_tutorial.save
    respond_with @customized_tutorial
  end

  def show

  end
  private
  def current_resource
    if params[:customized_course_id]
      @customized_course = CustomizedCourse.find(params[:customized_course_id])
      res                = @customized_course
    end
    if params[:id]
      @customized_tutorial = CustomizedTutorial.find(params[:id])
      res                  = @customized_tutorial
    end
    res
  end
end
