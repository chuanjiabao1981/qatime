class TeachersController < ApplicationController
  respond_to :html,:js

  def index
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher].permit!)
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
    @teacher = Teacher.find(params[:id])
    @curriculums = @teacher.find_or_create_curriculums
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
    
  end

  def questions
    @questions = Question.all.by_teacher(params[:teacher_id])
    .includes({learning_plan: :teachers},:vip_class,:student)
    .order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end

  def topics
    
  end

  def pass
    @teacher.update_attribute(:pass, true)
    render 'pass'
  end
  def unpass
    @teacher.update_attribute(:pass,false)
    render 'pass'
  end
  def destroy
    @teacher.destroy
    respond_with @teacher
  end
  def search
    @teachers = Teacher.all
    .where("name =? or email = ?",params[:search][:name],params[:search][:name]).paginate(page: params[:page],:per_page => 10)
    render 'index'
  end

  private
  def current_resource
    @teacher = Teacher.find(params[:id]) if params[:id]
  end
end
