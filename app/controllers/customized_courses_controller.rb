class CustomizedCoursesController < ApplicationController
  before_action :student_params_valid ,only:[:new,:create]
  def new
    @customized_course = @student.customized_courses.build
  end

  private
  def student_params_valid
    return redirect_to home_path unless params[:student_id]
    return redirect_to home_path unless @student = Student.find(params[:student_id])
  end
end
