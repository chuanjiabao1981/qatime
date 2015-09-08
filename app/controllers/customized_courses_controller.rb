class CustomizedCoursesController < ApplicationController
  respond_to :html,:js,:json
  layout "application"

  def new
    @customized_course = @student.customized_courses.build
    all_teacher
  end

  def create
    params[:customized_course][:teacher_ids].delete("")
    @customized_course = @student.customized_courses.build(params[:customized_course].permit!)
    all_teacher
    @customized_course.save
    respond_with @customized_course
  end

  def show

  end

  def edit
    all_teacher
  end

  def update
    params[:customized_course][:teacher_ids].delete("")
    @customized_course.update_attributes(params[:customized_course].permit!)
    respond_with @customized_course
  end

  def teachers
    @customized_course = CustomizedCourse.new unless @customized_course #如果没有制定则创建
    @teachers = Teacher.includes(:school).by_category(params[:category]).by_school(params[:school]).by_subject(params[:subject])
  end

  def topics
    @topics = @customized_course.topics.order(:created_at).paginate(page: params[:page])
  end
  private
  def all_teacher
    @teachers          = Teacher.by_category(@customized_course.category).by_subject(@customized_course.subject)
  end
  def current_resource
    if params[:student_id]
      @student = Student.find(params[:student_id])
      res      = @student
    end
    if params[:id]
      @customized_course = CustomizedCourse.find(params[:id]) if params[:id]
      res                = @customized_course
    end
    res
  end
end
