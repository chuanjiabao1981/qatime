class TeachersController < ApplicationController
  respond_to :html,:js,:json

  def index
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher].permit!)
    @teacher.build_account
    if @teacher.save
      SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @teacher.id)
      if signed_in?
        respond_with @teacher
      else
        sign_in(@teacher)
        redirect_to user_home_path
      end
    else
      render 'new',layout: 'application'
    end
  end

  def show
    #@teacher = Teacher.find(params[:id])
    #@curriculums = @teacher.find_or_create_curriculums
    render layout: 'teacher_home'
  end

  def edit
  end

  def update
    @teacher.update_attributes(params[:teacher].permit!)
    respond_with @teacher
  end

  def lessons_state
    if params[:state] == nil
      params[:state] = 'editing'
    end
    @lessons = Lesson.all.
        by_state(params[:state]).
        by_teacher(@teacher.id).
        order(:created_at).paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home'
  end

  def students
    @learning_plans = @teacher.learning_plans.paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home'
  end

  def curriculums
    @curriculums = @teacher.find_or_create_curriculums
    render layout: 'teacher_home'
  end

  def info
    if params[:fee].nil?
      @withdraws = @teacher.account.withdraws.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    else
      @earning_records      = @teacher.account.earning_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    end
    render layout: 'teacher_home'
  end

  def questions
    @questions = @teacher.questions.order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home'

  end

  def topics
    @topics = Topic.all.where(teacher_id: @teacher.id).where(topicable_type: Lesson.to_s).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home'
  end


  def homeworks
    @homeworks = Examination.by_customized_course_work.by_teacher(@teacher).order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
  end

  def customized_tutorial_topics
    @topics = Topic.all
                  .by_customized_course_issue
                  .by_customized_course_ids(@teacher.customized_course_ids)
                  .order("created_at desc")
                  .paginate(page: params[:page])
    render layout: 'teacher_home'
  end

  def solutions
    @solutions = Solution.by_customized_course_solution.where(customized_course_id: @teacher.customized_course_ids).order(created_at: :desc).paginate(page: params[:page])
  end


  def pass
    @teacher.update_attribute(:pass, true)
    render 'pass'
  end
  def unpass
    @teacher.update_attribute(:pass,false)
    render 'pass'
  end
  def keep_account
    KeepAccountWorker.perform_async(@teacher.id)
    flash[:success] = "#{Account.human_attribute_name(:keep_account)}进行中"
    redirect_to info_teacher_path(@teacher)
  end
  def destroy
    @teacher.destroy
    respond_with @teacher
  end
  def search
    @teachers = Teacher.all
    .where("name =? or email = ? or nick_name=?",params[:search][:name],params[:search][:name],params[:search][:name]).paginate(page: params[:page],:per_page => 10)
    render 'index'
  end

  def customized_courses
    @customized_courses = @teacher.customized_courses.paginate(page: params[:page],per_page: 10)
  end
  private
  def current_resource
    @teacher = Teacher.find(params[:id]) if params[:id]
  end
end
