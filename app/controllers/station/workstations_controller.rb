class Station::WorkstationsController < Station::BaseController
  skip_before_action :authorize, only: [:close_withdraw, :get_billing_item]
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

  def edit
    @workstation.build_coupon if @workstation.coupon.blank?
  end

  def update
    @workstation.clean_city_default_required!
    @workstation.set_default_of_city_required! if params[:is_default] == '1'

    if @workstation.update_attributes(workstation_params)
      flash_msg(:success)
      redirect_to station_workstation_path(@workstation)
    else
      flash_msg(:danger)
      render :edit
    end
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
      @change_records = @workstation.cash_account.change_records.in_changes.where(type: ['Payment::EarningRecord', 'Payment::WithdrawRefundRecord'])
    else
      @change_records = @workstation.cash_account.change_records.out_changes.where(type: ['Payment::WithdrawChangeRecord', 'Payment::SaleTaskPayRecord'])
    end
    @change_records = @change_records.order('created_at desc').paginate(page: params[:page])
  end

  # 1. 辅导班结账收入 business_type: Payment::BillingItem
  # 2. 专属课程结账收入 business_type: Payment::Billing
  # 3. 提现失败退款 business_type: Payment::Withdraw
  def get_billing_item
    @change_record = Payment::ChangeRecord.find(params[:change_record_id])
  end

  # 销售统计
  def statistics
    params[:genre] ||= 'order'
    params[:statistics_days] ||= Payment::Transaction.statistics_days.default_value
    @refund_statistics = @workstation.refunds.refunded
    @order_statistics = @workstation.orders.valid_order

    if params[:genre] == 'refund'
      @statistics = @refund_statistics
    else
      @statistics = @order_statistics
    end

    searchable = StatisticService::TransactionDirector.new(@statistics, params[:statistics_days], Time.now)
    searchable.search(params)

    @x_cate = searchable.x_cate
    @series_data = searchable.series_data

    # @x_cate = ['2-12', '2-13', '2-14', '2-15', '2-16', '2-17', '2-18']
    # @series_data = [0, 600, 300, 134, 90, 230, 200]
    @sales_total = searchable.sales_total(@order_statistics, @refund_statistics)
    @statistics = searchable.results.paginate(page: params[:page])
  end

  def teaching_lessons
    home_data = DataService::ManagerHomeData.new(@workstation)
    @teaching_lessons = home_data.teaching_lessons.paginate(page: params[:page])
  end

  private
  def withdraw_params
    params.require(:withdraw).permit(:amount, :payee, :captcha_confirmation)
  end

  def workstation_params
    params.require(:workstation).permit!
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
