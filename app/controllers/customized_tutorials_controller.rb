class CustomizedTutorialsController < ApplicationController
  layout "application"

  def index
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :asc)
  end

  def new
    @customized_tutorial = @customized_course.customized_tutorials.build
  end
  private
  def current_resource
    if params[:customized_course_id]
      @customized_course = CustomizedCourse.find(params[:customized_course_id])
    end
  end
end
