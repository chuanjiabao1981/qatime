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

    render layout: 'student_home_new'
  end

  # def security_setting
  #   session[:binding_email] = nil unless session[:binding_email] && params[:binding_email] == 'y'

  #   render layout: 'student_home_new'
  # end

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
    student_params = send("#{params[:by]}_params")

    if params[:by].to_s.to_sym == :password
      if @student.authenticate(params[:student][:current_password]) && @student.update(student_params)
        redirect_to edit_student_path(@student, cat: params[:cat]), notice: t("flash.notice.update_success")
      else
        render :edit, layout: "student_home_new"
      end
    else
      if @student.update(student_params)
        if params[:cat].to_s.to_sym == :edit_profile
          redirect_to info_student_path(@student), notice: t("flash.notice.update_success")
        elsif params[:cat].to_s.to_sym == :security_setting
          redirect_to edit_student_path(@student, cat: params[:cat]), notice: t("flash.notice.update_success")
        end
      else
        render :edit, layout: "student_home_new"
      end
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

  def email_captcha_for_change_email
    captcha_key = "captcha-#{params[:student][:input_email]}"

    @result = UserService::CaptchaManager.verify(session[captcha_key], params[:student][:input_captcha])
    if @result
      session[captcha_key] = nil
      session[:edit_email] = nil

      if @student.update(email: params[:student][:input_email])
        if params[:cat].to_s.to_sym == :edit_profile
          redirect_to info_student_path(@student), notice: t("flash.notice.update_success")
        elsif params[:cat].to_s.to_sym == :security_setting
          redirect_to edit_student_path(@student, cat: params[:cat]), notice: t("flash.notice.update_success")
        end
      else
        render :edit, layout: "student_home_new"
      end
    else
      render :edit, layout: "student_home_new"
    end
  end

  def validate_password
    if @student && @student.authenticate(params['password'])
      respond_to do |format|
        format.json { render json: @student, status: :accepted }
      end
    else
      respond_to do |format|
        format.json { render json: @student, status: :bad_request }
      end
    end
  end

  private

  def current_resource
    @student = Student.find(params[:id]) if params[:id]
  end

  def password_params
    params.require(:student).permit(:current_password, :password, :password_confirmation)
  end

  def email_params
    params.require(:student).permit(:email, :captcha)
  end

  def mobile_params
    params.require(:student).permit(:mobile, :captcha)
  end

  def parent_phone_params
    params.require(:student).permit(:parent_phone, :captcha)
  end

  def profile_params
    params.require(:student).permit(:name, :gender, :birthday, :grade, :province_id, :city_id, :description)
  end

  def avatar_params
    params.require(:student).permit(:avatar)
  end
end
