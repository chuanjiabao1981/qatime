class TeachersController < ApplicationController
  before_action :step_one_session, only: [:edit, :update]
  before_action :require_step_one_session, only: :update

  respond_to :html,:js,:json

  def index
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @teacher = Teacher.new
    if Rails.env.testing? || Rails.env.development?
      RegisterCode.able_code.last.try(:value) || RegisterCode.batch_make("20", School.last)
      @teacher.register_code_value = RegisterCode.able_code.last.value
    end
  end

  def create
    @teacher = Teacher.new(create_params).captcha_required!
    captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
    @teacher.captcha = captcha_manager.captcha_of(:register_captcha)
    @teacher.build_account
    if @teacher.save
      SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @teacher.id)
      session.delete("captcha-#{create_params[:login_mobile]}")
      sign_in(@teacher) unless signed_in?
      redirect_to edit_teacher_path(@teacher, cate: :register, by: :register)
    else
      render 'new', layout: 'application'
    end
  end

  def show
    #@teacher = Teacher.find(params[:id])
    #@curriculums = @teacher.find_or_create_curriculums
    render layout: 'teacher_home_new'
  end

  def edit
    if params[:cate] == "register"
      render layout: 'application'
    else
      render layout: 'teacher_home_new'
    end
  end

  def update
    if excute_update(update_by)
      if params[:cate] == "edit_profile"
        redirect_to info_teacher_path(@teacher, cate:  params[:cate]), notice: t("flash.notice.update_success")
      elsif params[:cate] == "register"
        redirect_to user_home_path, notice: t("flash.notice.register_success")
      else
        session.delete("change-#{update_by}-#{send_to}")
        redirect_to edit_teacher_path(@teacher, cate:  params[:cate]), notice: t("flash.notice.update_success")
      end
    else
      if params[:cate] == "register"
        render :edit, layout: 'application'
      else
        render :edit, layout: 'teacher_home_new'
      end
    end
  end

  def lessons_state
    if params[:state] == nil
      params[:state] = 'editing'
    end
    @lessons = Lesson.all.
        by_state(params[:state]).
        by_teacher(@teacher.id).
        order(:created_at).paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home_new'
  end

  def students
    @learning_plans = @teacher.learning_plans.paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home_new'
  end

  def curriculums
    @curriculums = @teacher.find_or_create_curriculums
    render layout: 'teacher_home_new'
  end

  def info
    # if params[:fee].nil?
    #   @withdraws = @teacher.account.withdraws.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @earning_records      = @teacher.account.earning_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end
    render layout: 'teacher_home_new'
  end

  def questions
    @questions = @teacher.questions.order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home_new'
  end

  def topics
    @topics = Topic.all.where(teacher_id: @teacher.id).where(topicable_type: Lesson.to_s).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'teacher_home_new'
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
    render layout: 'teacher_home_new'
  end

  def solutions
    @solutions = Solution.by_customized_course_solution.where(customized_course_id: @teacher.customized_course_ids).order(created_at: :desc).paginate(page: params[:page])
  end

  def notifications
    @action_notifications = @teacher.customized_course_action_notifications.paginate(page: params[:page])
    # @action_notifiactions =
    render layout: 'teacher_home_new'
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
    render layout: 'teacher_home_new'
  end
  private

  def current_resource
    @current_resource = @teacher = Teacher.find(params[:id]) if params[:id]
  end

  def password_params
    params.require(:teacher).permit(:current_password, :password, :password_confirmation)
  end

  def email_params
    params.require(:teacher).permit(:email, :captcha_confirmation)
  end

  def login_mobile_params
    params.require(:teacher).permit(:login_mobile, :captcha_confirmation)
  end

  def profile_params
    params.require(:teacher).permit(:name, :gender, :birthday, :province_id, :city_id, :school_id, :subject, :teaching_years, :desc, grade_range: [])
  end

  def avatar_params
    params.require(:teacher).permit(:crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def update_params(update_by)
    send("#{update_by}_params")
  end

  def create_params
    params.require(:teacher).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :register_code_value, :accept)
  end

  def register_params
    params.require(:teacher).permit(:name, :gender, :subject, :category, :birthday, :desc, :email, :email_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  # 根据跟新内容判断是否需要密码更新
  def excute_update(update_by)
    case update_by
    when "login_mobile"
      return update_login_mobile
    when "email"
      return update_email
    else
      update_params = update_params(update_by).map{|a| a unless a[1] == "" }.compact.to_h.symbolize_keys!
      return @teacher.update_with_password(update_params) if %w(password).include?(update_by)
      @teacher.update(update_params)
    end
  end

  def update_login_mobile
    send_to_was = @teacher.login_mobile
    # TODO 存储验证码的key区分开来，不同功能的验证码不使用
    captcha_manager = UserService::CaptchaManager.new(login_mobile_params[:login_mobile])
    @teacher.captcha = captcha_manager.captcha_of(:send_captcha)
    @teacher.update_with_captcha(login_mobile_params)
  ensure
    if @teacher.errors.blank?
      captcha_manager.expire_captch(:send_captcha)
      session.delete("change-login_mobile-#{send_to_was}")
    end
  end

  def update_email
    # TODO 存储验证码的key区分开来，不同功能的验证码不使用
    captcha_manager = UserService::CaptchaManager.new(email_params[:email])
    @teacher.captcha = captcha_manager.captcha_of(:change_email_captcha)
    @teacher.update_with_captcha(email_params)
  ensure
    if @teacher.errors.blank?
      captcha_manager.expire_captch(:change_email_captcha)
      session.delete("change-email-#{@teacher.login_mobile}")
    end
  end

  # 第一步验证成功以后会设置第一步对应的session
  # 用户修改个人信息根据需要检查是否存在第一步生成的session
  def require_step_one_session
    update_by = params[:by]
    return true if %w(email login_mobile).exclude?(update_by) || !UserService::CaptchaManager.expire?(@step_one_session)
    # 没有第一步的session跳转到编辑页面
    redirect_to edit_teacher_path(@teacher, by: params[:by], cate: params[:cate]), alert: t("flash.alert.please_verify_step_one_#{update_by}")
  end

  # 第一步验证通过后设置的session
  def step_one_session
    update_by = params[:by]
    send_to = case update_by
              when 'email'
                # 修改邮箱第一步验证用户手机
                @teacher.login_mobile
              when 'login_mobile'
                # 修改手机第一步验证用户现在的手机
                @teacher.login_mobile
              end
    step_one_session = session["change-#{update_by}-#{send_to}"]
    return unless step_one_session
    if step_one_session[:expire_at] > Time.now.to_i
      @step_one_session = step_one_session
    else
      session.delete("change-#{update_by}-#{send_to}")
    end
    @step_one_session
  end

  def update_by
    @update_by ||= params[:by]
  end

  def send_to
    @send_to ||= case update_by
                 when 'email'
                   # 修改邮箱第一步验证用户手机
                   @teacher.login_mobile
                 when 'login_mobile'
                   # 修改手机第一步验证用户现在的手机
                   @teacher.login_mobile
                 end
  end
end
