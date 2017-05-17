class TeachersController < ApplicationController
  before_action :set_owner
  before_action :step_one_session, only: [:edit, :update]
  before_action :require_step_one_session, only: :update

  respond_to :html,:js,:json

  def index
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @teacher = Teacher.new
    render layout: 'application_login'
    # if Rails.env.testing? || Rails.env.development?
    #   RegisterCode.able_code.last.try(:value) || RegisterCode.batch_make("20", School.last)
    #   @teacher.register_code_value = RegisterCode.able_code.last.value
    # end
  end

  def create
    @teacher = Teacher.new(create_params).register_columns_required!.captcha_required!
    captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
    @teacher.captcha = captcha_manager.captcha_of(:register_captcha)
    @teacher.build_account
    if @teacher.save
      session.delete("captcha-#{create_params[:login_mobile]}")
      sign_in(@teacher) unless signed_in?
      redirect_to edit_teacher_path(@teacher, cate: :register, by: :register)
    else
      render 'new', layout: 'application_login'
    end
  end

  def show
    render layout: 'v1/home'
  end

  def edit
    if params[:cate] == "register"
      render layout: 'application_login'
    else
      render layout: 'v1/home'
    end
  end

  def update
    if excute_update(update_by)
      if params[:cate] == "edit_profile"
        redirect_to info_teacher_path(@teacher, cate:  params[:cate]), notice: t("flash.notice.update_success")
      elsif params[:cate] == "register"
        SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @teacher.id)
        redirect_to params[:more_alter].present? ? info_teacher_path(@teacher) : user_home_path, notice: t("flash.notice.register_success")
      else
        session.delete("change-#{update_by}-#{send_to}")
        redirect_to edit_teacher_path(@teacher, cate:  params[:cate]), notice: t("flash.notice.update_success")
      end
    else
      if params[:cate] == "register"
        render :edit, layout: 'application_login'
      else
        render :edit, layout: 'v1/home'
      end
    end
  end

  def admin_edit
  end

  def admin_update
    update_params = params.require(:teacher).permit(:password, :login_mobile, :email, :parent_phone)

    # 更新密码时，验证密码
    @teacher.password_required! if update_params[:password]
    @teacher.update(update_params)
    # 获取更新的字段，便于更新提示
    @update_attr = update_params.keys.first
  end

  def lessons_state
    params[:state] ||= 'editing'
    @lessons = Lesson.by_state(params[:state]).by_teacher(@teacher.id).order(:created_at).paginate(page: params[:page], per_page: 10)
    render layout: 'v1/home'
  end

  def students
    @learning_plans = @teacher.learning_plans.paginate(page: params[:page], per_page: 10)
    render layout: 'v1/home'
  end

  def curriculums
    @curriculums = @teacher.find_or_create_curriculums
    render layout: 'v1/home'
  end

  def info
    # if params[:fee].nil?
    #   @withdraws = @teacher.account.withdraws.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @earning_records      = @teacher.account.earning_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end
    render layout: 'v1/home'
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
    render layout: 'teacher_home_new'
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
    @action_notifications = @teacher.notifications.paginate(page: params[:page])
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
    # 结账完成以后跳转到收入记录页面
    redirect_to payment.earning_records_user_path(@teacher)
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
    @customized_courses = @teacher.customized_courses.paginate(page: params[:page], per_page: 10)
    @customized_courses = @customized_courses.where(workstation: current_user.workstations) if current_user.manager?
    render layout: 'v1/home'
  end

  def profile
    teacher_data = DataService::TeacherData.new(@teacher)
    @courses = teacher_data.profile_courses.limit(6)
    @interactive_courses = teacher_data.profile_interactive_courses.limit(6)
    @video_courses = teacher_data.profile_video_courses.limit(6)

    @course_has_more = teacher_data.more_profile_course?
    @interactive_course_has_more = teacher_data.more_profile_interactive_course?
    @video_course_has_more = teacher_data.more_profile_video_course?
    render layout: 'v1/application'
  end

  private

  def current_resource
    @current_resource = @teacher = Teacher.find(params[:id]) if params[:id]
  end

  def set_owner
    @owner ||= current_resource
  end

  def payment_password_params
    params.require(:teacher).permit(:payment_password, :payment_password_confirmation, :payment_captcha_confirmation, :current_payment_password)
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
    params.require(:teacher).permit(:name, :nick_name, :gender, :birthday, :category, :province_id, :city_id, :school_id, :subject, :teaching_years, :desc, :crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def avatar_params
    params.require(:teacher).permit(:crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def update_params(update_by)
    send("#{update_by}_params")
  end

  def create_params
    # params.require(:teacher).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :register_code_value, :accept)
    params.require(:teacher).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :accept)
  end

  def register_params
    params.require(:teacher).permit(:name, :nick_name, :gender, :subject, :category, :school_id, :desc, :email, :email_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :avatar, \
    :province_id, :city_id, :school_name, :teaching_years)
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
    else
      update_params = update_params(update_by)
      if update_params[:email] == ""
        update_params.delete(:email)
        update_params.delete(:email_confirmation) if update_params[:email_confirmation] == ""
      end

      if %w(password).include?(update_by)
        @teacher.password_required!
        return @teacher.update_with_password(update_params)
      end

      if update_params[:school_name].present?
        school = School.find_or_create_by(city_id: update_params[:city_id],name: update_params[:school_name])
        update_params[:school] = school
      end

      teaching_years_flag = Teacher.teaching_years.options.find{|years| years.first == update_params[:teaching_years]}
      if teaching_years_flag.present?
        update_params[:teaching_years] = teaching_years_flag.last
      end

      if @teacher.avatar.blank? && update_params[:avatar].blank?
        @teacher.use_default_avatar
      end

      @teacher.teacher_columns_required!
      @teacher.context = :edit_profile if params[:cate] == 'edit_profile'
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
      session.delete("change-login_mobile-#{send_to_was}") if send_to_was
    end
  end

  def update_payment_password
    if payment_password_params[:current_payment_password].present?
      return @teacher.reset_payment_pwd(payment_password_params)
    end
    captcha_manager = UserService::CaptchaManager.new(@teacher.login_mobile)
    @teacher.payment_captcha = captcha_manager.captcha_of(:payment_password)
    @teacher.update_payment_pwd(payment_password_params)
  ensure
    if @teacher.errors.blank?
      captcha_manager.expire_captch(:payment_password) if captcha_manager
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
    return true if %w(email login_mobile).exclude?(update_by) || @teacher.login_mobile.blank? || !UserService::CaptchaManager.expire?(@step_one_session)
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
