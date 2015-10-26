class CustomizedCoursesController < ApplicationController
  respond_to :html,:js,:json
  layout "application"

  def new
    @customized_course = @student.customized_courses.build
    all_teacher
    @workstations = Workstation.by_manager_id(current_user.id)
  end

  def create
    params[:customized_course][:teacher_ids].delete("")
    @customized_course = @student.customized_courses.build(params[:customized_course].permit!)
    all_teacher
    @customized_course.creator_id = current_user.id
    @customized_course.save
    respond_with @customized_course
  end

  def show
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :desc).paginate(page: params[:page])
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
    @topics = Topic.by_customized_course_id(params[:id]).by_customized_course_issue.order(created_at: :desc).paginate(page: params[:page])

  end

  def homeworks
    @homeworks = Homework.h_index_eager_load.by_customized_course_id(@customized_course.id).order(created_at: :desc).paginate(page: params[:page])
  end
  def solutions
    @solutions = Solution.by_customized_course_id(params[:id]).order(created_at: :desc).paginate(page: params[:page])
  end

  def course_issues
    @course_issues = @customized_course.course_issues.paginate(page:params[:page])
  end

  def get_sale_price
    category = params[:category]
    customized_course_type  = params[:customized_course_type]
    teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(category, customized_course_type)
    @sale_price = teacher_price + platform_price
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
