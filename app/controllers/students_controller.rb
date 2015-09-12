class StudentsController < ApplicationController
  respond_to :html

  def index
    @students = Student.all.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)

  end
  def new
    @student = Student.new
  end
  def create
    @student = Student.new(params[:student].permit!)
    @student.build_account
    if @student.save
      SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @student.id)
      if signed_in?
        respond_with @student
      else
        sign_in(@student)
        redirect_to user_home_path
      end
    else
      render 'new'
    end
  end
  def show
    render :info,layout: 'student_home'
  end
  def edit
  end

  def info
    render layout: 'student_home'
  end


  def questions
    @questions = Question.all.where("student_id=?",@student.id).
        includes({learning_plan: :teachers},:vip_class,:student).
        order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end

  def topics
    @topics = Topic.all.where(author_id: @student.id).where(topicable_type: Lesson.to_s).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'student_home'
  end

  def teachers
    @learning_plans = @student.learning_plans.paginate(page: params[:page],:per_page => 10)
    render layout: 'student_home'
  end

  def customized_tutorial_topics
    @topics = Topic.all.where(author_id: @student.id).by_customized_course(params)
    render layout: 'student_home'
  end


  def customized_courses
    @customized_courses = @student.customized_courses.paginate(page: params[:page],per_page: 10)
  end
  def update
    if @student.update_attributes(params[:student].permit!)
      redirect_to student_path(@student)
    else
      render 'edit'
    end
  end
  def search
    @students = Student.all
                .where("name =? or email = ?",params[:search][:name],params[:search][:name])
  end

  def destroy
    @student.destroy
    respond_with @student
  end
  private
  def current_resource
    @student = Student.find(params[:id]) if params[:id]
  end
end
