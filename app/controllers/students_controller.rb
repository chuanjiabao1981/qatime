class StudentsController < ApplicationController
  before_action :step_one_session, only: [:edit, :update]
  before_action :require_step_one_session, only: :update
  before_action :set_captcha_code, only: :update

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
    @student = Student.new(create_params).captcha_required!
    captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
    @student.captcha = captcha_manager.captcha_of(:register_captcha)
    @student.build_account
    if @student.save
      SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: @student.id)
      # 删除注册验证码
      captcha_manager.expire_captch(:register_captcha)
      sign_in(@student) unless signed_in?
      redirect_to edit_student_path(@student, cate: :register, by: :register)
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
    render layout: 'student_home_new'
  end

  def edit
    if params[:cate] == "register"
      render layout: 'application'
    else
      render layout: 'student_home_new'
    end
  end

  def info
    # if params[:fee].nil?
    #   @deposits = @student.account.deposits.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # else
    #   @consumption_records      = @student.account.consumption_records.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)
    # end

    render layout: 'student_home_new'
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
    @customized_courses = @student.customized_courses.paginate(page: params[:page],per_page: 10)
    render layout: 'student_home_new'
  end

  def notifications
    @action_notifications = @student.customized_course_action_notifications.paginate(page: params[:page])
    render layout: 'student_home_new'
  end

  def update
    if excute_update(update_by)
      if params[:cate] == "edit_profile"
        redirect_to info_student_path(@student, cate:  params[:cate]), notice: t("flash.notice.update_success")
      elsif params[:cate] == "register"
        redirect_to user_home_path, notice: t("flash.notice.register_success")
      else
        session.delete("change-#{update_by}-#{send_to}")
        redirect_to edit_student_path(@student, cate:  params[:cate]), notice: t("flash.notice.update_success")
      end
    else
      if params[:cate] == "register"
        render :edit, layout: 'application'
      else
        render :edit, layout: 'student_home_new'
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
    @current_resource = @student = Student.find(params[:id]) if params[:id]
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
    params.require(:student).permit(:name, :gender, :birthday, :grade, :province_id, :city_id, :desc)
  end

  def avatar_params
    params.require(:student).permit(:crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  def update_params(update_by)
    send("#{update_by}_params")
  end

  def create_params
    params.require(:student).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :register_code_value, :accept)
  end

  def register_params
    params.require(:student).permit(:name, :gender, :grade, :birthday, :desc, :email, :email_confirmation, :parent_phone, :parent_phone_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :avatar)
  end

  # 根据跟新内容判断是否需要密码更新
  def excute_update(update_by)
    update_params = update_params(update_by).map{|a| a unless a[1] == "" }.compact.to_h.symbolize_keys!
    return @student.update_with_password(update_params) if %w(password parent_phone).include?(update_by)
    @student.update(update_params)
  end

  # 第一步验证成功以后会设置第一步对应的session
  # 用户修改个人信息根据需要检查是否存在第一步生成的session
  def require_step_one_session
    update_by = params[:by]
    return true if %w(email login_mobile).exclude?(update_by)  || !UserService::CaptchaManager.expire?(@step_one_session)
    # 没有第一步的session跳转到编辑页面
    redirect_to edit_student_path(@student, by: params[:by], cate: params[:cate]), alert: t("flash.alert.please_verify_step_one_#{update_by}")
  end

  # 第一步验证通过后设置的session
  def step_one_session
    update_by = params[:by]
    send_to = case update_by
              when 'email'
                # 修改邮箱第一步验证用户手机
                @student.mobile
              when 'mobile'
                # 修改手机第一步验证用户现在的手机
                @student.mobile
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
                   @student.mobile
                 when 'mobile'
                   # 修改手机第一步验证用户现在的手机
                   @student.mobile
                 end
  end
end
