class Station::WorkstationsController < Station::BaseController
  skip_before_action :authorize, only: [:close_withdraw]
  before_action :set_city

  def customized_courses
    @customized_courses = @workstation.customized_courses.order(:created_at).paginate(page: params[:page])
  end

  def schools
    @schools = @city.schools.order(:created_at).paginate(page: params[:page])
  end

  def teachers
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page])
  end

  def students
    @students = Student.all.order(:created_at).paginate(page: params[:page])
  end

  # 销售
  def sellers
    @sellers = @workstation.sellers.order(id: :desc).paginate(page: params[:page])
  end

  # 客服
  def waiters
    @waiters = @workstation.waiters.order(id: :desc).paginate(page: params[:page])
  end

  def action_records
    @action_records = @workstation.action_records.order(id: :desc).paginate(page: params[:page])
  end

  def show
  end

  def fund
    @withdraw = Payment::Withdraw.new(pay_type: :station)
  end

  # 申请提现
  def withdraw
    @withdraw = current_user.payment_withdraws.new(withdraw_params).captcha_required!
    @withdraw.pay_type = :station
    @withdraw.owner = @workstation
    captcha_manager = UserService::CaptchaManager.new(@workstation.manager.try(:login_mobile))
    @withdraw.captcha = captcha_manager.captcha_of(:withdraw_cash)

    if @withdraw.save
      render js: "window.location.reload();"
      return
    end
  end

  def close_withdraw
    withdraw = Payment::Withdraw.find(params[:withdraw_id])
    withdraw.update_attribute(:close, true)
    respond_to do |format|
      format.js {
        render js: "$('.withdraw_#{withdraw.id}').remove();"
      }
    end
  end

  # 出入账记录
  def change_records
    params[:from] ||= 'out'
    if params[:from] == 'in'
      @change_records = Payment::ChangeRecord.in_changes
    else
      @change_records = Payment::ChangeRecord.out_changes.where(type: ['Payment::WithdrawRecord'])
    end
    @change_records = @change_records.paginate(page: params[:page])
  end

  private
  def withdraw_params
    params.require(:withdraw).permit(:amount, :payee, :captcha_confirmation)
  end

  def set_workstation
    @workstation ||= Workstation.find(params[:id])
  end

  def set_city
    @city = @workstation.city
  end

  def current_resource
    set_workstation
  end
end
