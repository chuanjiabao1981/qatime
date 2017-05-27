class CustomizedCoursesController < ApplicationController
  include QaCustomizedCourse
  before_action :customized_course_associations_prepare
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
    @customized_course.build_customized_course_message_board
    @customized_course.creator_id = current_user.id
    @customized_course.save
    respond_with @customized_course
  end

  def show
    @customized_tutorials = @customized_course.customized_tutorials.order(created_at: :desc).paginate(page: params[:page])
  end

  def edit
    @customized_course = CustomizedCourse.find(params[:id])
    all_teacher
  end

  def update
    if not params[:customized_course][:teacher_ids].nil?
      params[:customized_course][:teacher_ids].delete("")
    end
    @customized_course.update_attributes(params[:customized_course].permit!)
    respond_with @customized_course
  end

  def update_desc
    @customized_course.update(desc: params[:desc]) if params[:desc]
  end

  def teachers
    @customized_course = CustomizedCourse.new unless @customized_course #如果没有制定则创建
    @teachers = Teacher.includes(:school).by_category(params[:category]).by_school(params[:school]).by_subject(params[:subject])
  end

  def topics
    @topics = Topic.by_customized_course_id(params[:id]).by_customized_course_issue.order(created_at: :desc).paginate(page: params[:page])

  end

  def homeworks
    @homeworks = Examination.by_customized_course_work.h_index_eager_load.by_customized_course_id(@customized_course.id).order(created_at: :desc).paginate(page: params[:page])
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
    is_new_record = params[:is_new_record]
    customized_course_id = params[:customized_course_id]

    if is_new_record == "new"
      teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(category, customized_course_type)
      @sale_price = teacher_price + platform_price
    else
      customized_course    = CustomizedCourse.find(customized_course_id)
      if customized_course.category == category and customized_course.customized_course_type == customized_course_type
        @sale_price = customized_course.teacher_price + customized_course.platform_price
      else
        teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(category, customized_course_type)
        @sale_price = teacher_price + platform_price
      end
    end
  end

  def action_records
    @action_records = ActionRecord.where(customized_course_id: @customized_course).order(created_at: :desc).paginate(page: params[:page])
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
