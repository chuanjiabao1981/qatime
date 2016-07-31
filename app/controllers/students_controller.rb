class StudentsController < ApplicationController
  respond_to :html

  def index
    @students = Student.all.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)

  end

  def new
    @student = Student.new
    if Rails.env.testing? || Rails.env.development?
      RegisterCode.able_code.last.try(:value) || RegisterCode.batch_make("20", School.last)
      @student.register_code_value = RegisterCode.able_code.last.value
    end
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
    # if params[:fee].nil?
    #   @deposits = @student.account.deposits.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @consumption_records      = @student.account.consumption_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end
    render layout: 'student_home'
  end
  def edit
    render layout: 'student_home_new'
  end

  def info
    # if params[:fee].nil?
    #   @deposits = @student.account.deposits.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @consumption_records      = @student.account.consumption_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end
    session[:binding_email] = nil unless session[:binding_email] && params[:binding_email] == 'y'

    render layout: 'student_home_new'
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
    @topics = Topic.all.by_author_id(@student.id)
                  .by_customized_course_issue
                  .order("created_at desc")
                  .paginate(page: params[:page])
    render layout: 'student_home'
  end

  def homeworks
    @homeworks = Examination.by_student(@student).by_customized_course_work.paginate(page: params[:page],:per_page => 10)
  end
  def solutions
    @solutions = Solution.all.where(customized_course_id: @student.customized_course_ids).order(created_at: :desc).paginate(page: params[:page])
  end

  def customized_courses
    @customized_courses = @student.customized_courses.paginate(page: params[:page],per_page: 10)
  end

  def notifications
    @action_notifications = @student.customized_course_action_notifications.paginate(page: params[:page])
  end
  def update
    if @student.update_attributes(params[:student].permit!)
      redirect_to info_student_path(@student)
    else
      render 'edit'
    end
  end
  def search
    @students = Student.all
                .where("name =? or email = ?",params[:search][:name],params[:search][:name])
  end

  def account

  end

  def destroy
    @student.destroy
    respond_with @student
  end

  def auth_user_for_change_email
    captcha = '%04d' % rand(10000)
    session[:binding_email] = {
      send_to: @student.mobile,
      captcha: captcha,
      expired_at: 5.minutes.since.to_i,
      step: 1
    }

    SmsWorker.perform_async(SmsWorker::SEND_CAPTCHA, mobile: @student.mobile, captcha: captcha)
    respond_to do |format|
      format.json { render json: @student, status: :accepted }
    end
  end

  def mobile_captcha_for_change_email
    if @student.validate_email_captcha(session[:binding_email], params.require(:student).permit(:input_captcha))
      session[:binding_email][:step] = 2
      redirect_to action: :info, safe: :y, binding_email: :y
    else
      redirect_to info_student_path(@student, params:{safe: :y, binding_email: :y}), alert: @student.errors[:base].join(',')
    end
  end

  def send_email_for_change_email
    input_email = params[:input_email]
    if input_email =~ /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/

      captcha = '%04d' % rand(10000)

      session[:binding_email] = {
        send_to: input_email,
        captcha: captcha,
        expired_at: 5.minutes.since.to_i,
        step: 2
      }
      UserMailer.send_captcha(@student, captcha).deliver

      redirect_to action: :info, safe: :y, binding_email: :y
    else
      redirect_to action: :info, safe: :y, binding_email: :y
    end
  end

  def emial_captcha_for_change_email
    @student.validate_email_captcha(session[:binding_email], params.require(:student).permit(:input_captcha, :input_email))
    if(session[:binding_email][:expired_at] > Time.zone.now.to_i && params[:input_captcha_code] == session[:binding_email][:captcha])

      session[:binding_email][:step] = 2
      redirect_to action: :info, safe: :y, binding_email: :y
    else
      redirect_to info_student_path(@student, params:{safe: :y, binding_email: :y}), alert: @student.errors[:base].join(',')
    end
  end

  private

  def current_resource
    @student = Student.find(params[:id]) if params[:id]
  end
end
