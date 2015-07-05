class CustomizedCoursesController < ApplicationController
  respond_to :html,:js,:json

  before_action :student_params_valid ,only:[:new,:create]
  def new
    @customized_course = @student.customized_courses.build
  end


  def teachers
    @customized_course = CustomizedCourse.new
    @teachers = Teacher.by_category(params[:category]).by_school(params[:school]).by_subject(params[:subject])
  end
  private
  def student_params_valid
    return redirect_to home_path unless params[:student_id]
    return redirect_to home_path unless @student = Student.find(params[:student_id])
  end
end
