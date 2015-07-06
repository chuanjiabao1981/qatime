class CustomizedCoursesController < ApplicationController
  respond_to :html,:js,:json

  def new
    @customized_course = @student.customized_courses.build
    @teachers          = Teacher.by_category(@customized_course.category).by_subject(@customized_course.subject)
  end

  def create
    params[:customized_course][:teacher_ids].delete("")
    @customized_course = @student.customized_courses.build(params[:customized_course].permit!)
    @teachers          = Teacher.by_category(@customized_course.category).by_subject(@customized_course.subject)
    @customized_course.save
    respond_with @customized_course
  end

  def show

  end

  def teachers
    @customized_course = CustomizedCourse.new
    @teachers = Teacher.includes(:school).by_category(params[:category]).by_school(params[:school]).by_subject(params[:subject])
  end
  private
  def current_resource
    if params[:id]
      @customized_course = CustomizedCourse.find(params[:id]) if params[:id]
    elsif params[:student_id]
      @student = Student.find(params[:student_id])
    end
  end
end
