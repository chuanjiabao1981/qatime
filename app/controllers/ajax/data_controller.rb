class Ajax::DataController < ApplicationController
  before_action :set_variable, only: [:option_cities, :option_schools]
  skip_before_action :authorize

  def option_cities
    respond_to do |format|
      format.js
    end
  end

  def option_schools
    respond_to do |format|
      format.js
    end
  end

  def option_courses
    @course_type = params[:course_type]
    @courses = LiveStudio::Course.all if @course_type == 'course'
    @courses = LiveStudio::InteractiveCourse.all if @course_type == 'interactive_course'
    # @courses = LiveStudio::CustomizedGroup.all if @course_type == 'group'

    respond_to do |format|
      format.js
    end
  end

  def option_lessons
    @course_type = params[:course_type]
    if params[:course_id].present?
      @lessons = LiveStudio::Course.find(params[:course_id]).lessons.merged if @course_type == 'course'
      @lessons = LiveStudio::InteractiveCourse.find(params[:course_id]).interactive_lessons.merged if @course_type == 'interactive_course'
      # @lessons = LiveStudio::CustomizedGroup.find(params[:course_id]).scheduled_lessons.merged if @course_type == 'group'
    end

    respond_to do |format|
      format.js
    end
  end

  def home_curriculums
    @curriculums = Curriculum.by_subject(params[:subject]).limit(8)
    respond_to do |format|
      format.html{ render layout: false}
    end
  end

  def home_questions
    @questions = Question.all.includes({learning_plan: :teachers},:vip_class,:student).order("created_at desc").limit(4)
    respond_to do |format|
      format.html{ render layout: false }
    end
  end

  def home_teachers
    teachers = DataService::HomeData.new(params[:city_id].presence).teachers
    @recommend_teachers = teachers.order(:index).paginate(page: params[:teacher_page], per_page: 6)
    if @recommend_teachers.blank?
      params[:teacher_page] = 1
      @recommend_teachers = @recommend_teachers.page(params[:teacher_page])
    end
    params[:teacher_page] = params[:teacher_page].to_i + 1
  end

  def teacher_profile_courses
    @teacher = Teacher.find(params[:teacher_id])
    teacher_data = DataService::TeacherData.new(@teacher)
    case params[:cate]
      when 'courses'
        @courses = teacher_data.profile_courses
      when 'interactive_courses'
        @courses = teacher_data.profile_interactive_courses
      when 'video_courses'
        @courses = teacher_data.profile_video_courses
      else
        @courses = []
    end
  end

  private

  def set_variable
    set_cities if params[:second]
    set_schools if params[:third]
  end

  def set_cities
    @province_id = (params[:teacher] || params[:student])[:province_id]
    @cities = City.where(province_id: @province_id).order(:id)
    @cities = @cities.has_default_workstation if params[:scope]
    @cities
  end

  def set_schools
    @city_id = (params[:teacher] || params[:student])[:city_id]
    @schools = @city_id.blank? ? @cities.first.try(:schools).to_a : City.find(@city_id).schools
  end
end
