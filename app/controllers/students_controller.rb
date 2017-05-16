class StudentsController < ApplicationController
  before_action :set_owner
  before_action :step_one_session, only: [:edit, :update]
  before_action :require_step_one_session, only: :update

  respond_to :html

  def index
    @students = Student.all.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @student = Student.new
    render layout: 'application_login'
    # if Rails.env.testing? || Rails.env.development?
    #   RegisterCode.able_code.last.try(:value) || RegisterCode.batch_make("20", School.last)
    #   @student.register_code_value = RegisterCode.able_code.last.value
    # end
  end

  def create
    @student = Student.new(create_params).register_columns_required!.captcha_required!
    captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
    @student.captcha = captcha_manager.captcha_of(:register_captcha)
    @student.build_account
    if @student.save
      session.delete("captcha-#{create_params[:login_mobile]}")
      sign_in(@student) unless signed_in?
      redirect_to edit_student_path(@student, cate: :register, by: :register)
    else
      p @student.errors
      render 'new', layout: 'application_login'
    end
  end

  def show
    render layout: 'student_home_new'
  end

  def edit
    if params[:cate] == "register"
      render layout: 'application_login'
    else
      render layout: 'v1/home'
    end
  end

  def admin_edit
  end

  def admin_update
    update_params = params.require(:student).permit(:password, :login_mobile, :email, :parent_phone)

    # 更新密码时，验证密码
    @student.password_required! if update_params[:password]

    @student.update(update_params)

    # 获取更新的字段，便于更新提示
    @update_attr = update_params.keys.first
  end

  def info
    # if params[:fee].nil?
    #   @deposits = @student.account.deposits.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @consumption_records      = @student.account.consumption_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end
    render layout: 'v1/home'
  end

  def questions
    @questions = Question.all.where("student_id=?",@student.id).
        includes({learning_plan: :teachers},:vip_class,:student).
        order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end

  def topics
    @topics = Topic.all.where(author_id: @student.id).where(topicable_type: Lesson.to_s).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    render layout: 'student_home_new'
  end

  def teachers
    @learning_plans = @student.learning_plans.paginate(page: params[:page],:per_page => 10)
    render layout: 'student_home_new'
  end

  def customized_tutorial_topics
    @topics = Topic.all.by_author_id(@student.id)
                  .by_customized_course_issue
                  .order("created_at desc")
                  .paginate(page: params[:page])
    render layout: 'student_home_new'
  end

  def homeworks
    @homeworks = Examination.by_student(@student).by_customized_course_work.paginate(page: params[:page],:per_page => 10)
    render layout: 'student_home_new'
  end
  def solutions
    @solutions = Solution.all.where(customized_course_id: @student.customized_course_ids).order(created_at: :desc).paginate(page: params[:page])
  end

  def customized_courses
    @customized_courses = @student.customized_courses.paginate(page: params[:page], per_page: 10)
    @customized_courses = @customized_courses.where(workstation: current_user.workstations) if current_user.manager?
    render layout: 'v1/home'
  end

  def notifications
    @action_notifications = @student.notifications.paginate(page: params[:page])
    render layout: 'student_home_new'
  end

  def update
    if excute_update(update_by)
      if params[:cate] == "edit_profile"
        redirect_to info_student_path(@student, cate: params[:cate]), notice: t("flash.notice.update_success")
      elsif params[:cate] == "register"
        SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @student.id)
        return_to = params[:return_to].blank? ? user_home_path : params[:return_to]
        redirect_to return_to, notice: t("flash.notice.register_success")
      else
        session.delete("change-#{update_by}-#{send_to}")
        redirect_to edit_student_path(@student, cate: params[:cate]), notice: t("flash.notice.update_success")
      end
    else
      if params[:cate] == "register"
        render :edit, layout: 'application_login'
      else
        render :edit, layout: 'v1/home'
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

  private

  def current_resource
    @current_resource = @student = User.find(params[:id]) if params[:id]
  end

  def set_owner
    @owner ||= current_resource
  end

  def password_params
    params.require(:student).permit(:current_password, :password, :password_confirmation)
  end

  def email_params
    params.require(:student).permit(:email, :captcha_confirmation)
  end

  def login_mobile_params
    params.require(:student).permit(:login_mobile, :captcha_confirmation)
  end

  def parent_phone_params
    params.require(:student).permit(:current_password, :parent_phone, :captcha_confirmation)
  end

  def profile_params
    params.require(:student).permit(:name, :gender, :birthday, :grade, :province_id, :city_id, :school_id, :desc, :crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def avatar_params
    params.require(:student).permit(:crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def payment_password_params
    params.require(:student).permit(:payment_password, :payment_password_confirmation, :payment_captcha_confirmation, :current_payment_password)
  end

  def update_params(update_by)
    send("#{update_by}_params")
  end

  def create_params
    # params.require(:student).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :register_code_value, :accept)
    params.require(:student).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :accept)
  end

  def register_params
    params.require(:student).permit(:name, :gender, :grade, :desc, :email, :email_confirmation, :parent_phone, :parent_phone_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :avatar, :city_id, :province_id)
  end

  # 根据跟新内容判断是否需要密码更新
  def excute_update(update_by)
    case update_by
    when "login_mobile"
      return update_login_mobile
    when "email"
      return update_email
    when 'payment_password'
      return update_payment_password
    when "parent_phone"
      return update_parent_phone
    else
      update_params = update_params(update_by)
      if update_params[:email] == ""
        update_params.delete(:email)
        update_params.delete(:email_confirmation) if update_params[:email_confirmation] == ""
      end

      if update_params[:parent_phone] == ""
        update_params.delete(:parent_phone)
        update_params.delete(:parent_phone_confirmation) if update_params[:parent_phone_confirmation] == ""
      end

      if %w(password).include?(update_by)
        @student.password_required!
        return @student.update_with_password(update_params)
      end

      if @student.avatar.blank? && update_params[:avatar].blank?
        @student.use_default_avatar
      end

      @student.student_columns_required!
      @student.update(update_params)
    end
  end

  def update_login_mobile
    send_to_was = @student.login_mobile
    # TODO 存储验证码的key区分开来，不同功能的验证码不使用
    captcha_manager = UserService::CaptchaManager.new(login_mobile_params[:login_mobile])
    @student.captcha = captcha_manager.captcha_of(:send_captcha)
    @student.update_with_captcha(login_mobile_params)
  ensure
    if @student.errors.blank?
      captcha_manager.expire_captch(:send_captcha)
      session.delete("change-login_mobile-#{send_to_was}")
    end
  end

  def update_email
    # TODO 存储验证码的key区分开来，不同功能的验证码不使用
    captcha_manager = UserService::CaptchaManager.new(email_params[:email])
    @student.captcha = captcha_manager.captcha_of(:change_email_captcha)
    @student.update_with_captcha(email_params)
  ensure
    if @student.errors.blank?
      captcha_manager.expire_captch(:change_email_captcha)
      session.delete("change-email-#{@student.login_mobile}")
    end
  end

  def update_payment_password
    if payment_password_params[:current_payment_password].present?
      return @student.reset_payment_pwd(payment_password_params)
    end
    captcha_manager = UserService::CaptchaManager.new(@student.login_mobile)
    @student.payment_captcha = captcha_manager.captcha_of(:payment_password)
    @student.update_payment_pwd(payment_password_params)
  ensure
    if @student.errors.blank?
      captcha_manager.expire_captch(:payment_password) if captcha_manager
    end
  end

  def update_parent_phone
    # TODO 存储验证码的key区分开来，不同功能的验证码不使用
    captcha_manager = UserService::CaptchaManager.new(parent_phone_params[:parent_phone])
    @student.captcha = captcha_manager.captcha_of(:send_captcha)
    @student.captcha_required!
    @student.update_with_password(parent_phone_params)
  ensure
    if @student.errors.blank?
      captcha_manager.expire_captch(:send_captcha)
      session.delete("change-parent_phone-#{@student.parent_phone_was}")
    end
  end

  # 第一步验证成功以后会设置第一步对应的session
  # 用户修改个人信息根据需要检查是否存在第一步生成的session
  def require_step_one_session
    update_by = params[:by]
    return true if %w(email login_mobile).exclude?(update_by)  || @student.login_mobile.blank? || !UserService::CaptchaManager.expire?(@step_one_session)
    # 没有第一步的session跳转到编辑页面
    redirect_to edit_student_path(@student, by: params[:by], cate: params[:cate]), alert: t("flash.alert.please_verify_step_one_#{update_by}")
  end

  # 第一步验证通过后设置的session
  def step_one_session
    update_by = params[:by]
    send_to = case update_by
              when 'email'
                # 修改邮箱第一步验证用户手机
                @student.login_mobile
              when 'login_mobile'
                # 修改手机第一步验证用户现在的手机
                @student.login_mobile
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

  def set_captcha_code
    update_by = params[:by]
    # 只有邮箱、手机、家长手机修改需要检查验证码
    return true if %w(email login_mobile parent_phone).exclude?(update_by)
    captcha_manager = UserService::CaptchaManager.new(update_params(update_by)[update_by.to_sym])
    @student.captcha = captcha_manager.captcha_of(session[captcha_key])
  end

  def update_by
    @update_by ||= params[:by]
  end

  def send_to
    @send_to ||= case update_by
                 when 'email'
                   # 修改邮箱第一步验证用户手机
                   @student.login_mobile
                 when 'login_mobile'
                   # 修改手机第一步验证用户现在的手机
                   @student.login_mobile
                 end
  end
end
