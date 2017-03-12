class Admins::WorkstationsController < ApplicationController

  before_action :find_workstation, only: [:edit, :update, :show, :destroy, :change_status, :fund, :change_records, :statistics]

  respond_to :html
  layout "admin_home"

  def index
    @workstations = Workstation.order(id: :desc).paginate(page: params[:page])
  end

  def new
    @workstation = Workstation.new
    @workstation.build_coupon
  end

  def create
    @workstation = Workstation.new(workstation_params)
    @workstation.build_account
    if @workstation.save
      flash_msg(:success)
      redirect_to admins_workstations_path
    else
      flash_msg(:danger)
      render :new
    end
    # 这里需要增加短信通知
  end

  def show
  end

  def edit
    @workstation.build_coupon if @workstation.coupon.blank?
  end

  def update
    if @workstation.update_attributes(workstation_params)
      flash_msg(:success)
      redirect_to admins_workstation_path(@workstation)
    else
      flash_msg(:danger)
      render :edit
    end
  end

  def destroy
    @workstation.destroy
    redirect_to admins_workstations_path
  end

  def change_status
    @workstation.may_run? ? @workstation.run! : @workstation.stop!

    respond_to do |format|
      format.html {}
      format.js {
        render js: "window.location.reload();"
      }
    end
  end

  def fund

  end

  # 出入账记录
  def change_records
    params[:from] ||= 'out'
    if params[:form] == 'in'
      @change_records = Payment::ChangeRecord.in_changes
    else
      @change_records = Payment::ChangeRecord.out_changes.where(type: ['Payment::WithdrawRecord'])
    end
    @change_records = @change_records.paginate(page: params[:page])
  end

  # 销售统计
  def statistics
    params[:genre] ||= 'order'
    params[:statistics_days] ||= Payment::Transaction.statistics_days.default_value
    @refund_statistics = @workstation.refunds
    @order_statistics = @workstation.orders

    if params[:genre] == 'refund'
      @statistics = @refund_statistics
    else
      @statistics = @order_statistics
    end

    date_now = Date.today
    case params[:statistics_days]
      when 'week' # 7天
        @start_day = date_now.last_week.at_beginning_of_week
        @end_day = date_now.last_week.at_end_of_week
        # X轴日期
        @dates = (@start_day..@end_day).to_a
        # 日期统计
        @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      when 'month' # 4周
        @start_day = date_now.last_month.at_beginning_of_month
        @end_day = date_now.last_month.at_end_of_month
        @dates = (@start_day..@end_day).select {|x| x.monday?}
        @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      when 'month2' # 8周
        @start_day = date_now.months_ago(2).at_beginning_of_month
        @end_day = date_now.at_beginning_of_month.yesterday
        @dates = (@start_day..@end_day).select {|x| x.monday?}
        @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      when 'month3' # 12周
        @start_day = date_now.months_ago(3).at_beginning_of_month
        @end_day = date_now.at_beginning_of_month.yesterday
        @dates = (@start_day..@end_day).select { |x| x.monday? }
        @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      when 'month6' # 6月
        @start_day = date_now.months_ago(6).at_beginning_of_month
        @end_day = date_now.at_beginning_of_month.yesterday
        # 每月1号代表统计
        @dates = (@start_day..@end_day).select { |x| x.day == 1 }
        @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      when 'year' # 12月
        @start_day = date_now.years_ago(1).at_beginning_of_year
        @end_day = date_now.at_beginning_of_year.yesterday
        @dates = (@start_day..@end_day).select { |x| x.day == 1 }
        @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      else
        @start_day = date_now.last_week.at_beginning_of_week
        @end_day = date_now.last_week.at_end_of_week
        # X轴日期
        @dates = (@start_day..@end_day).to_a
        # 日期统计
        @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
    end

    # 明细数据
    @statistics = @statistics.includes(:product, :user).where(created_at: (@start_day..@end_day)).paginate(page: params[:page])

    @x_cate = @dates.inject([]) { |r, v| r << v.strftime("%m-%d") }
    # 月份显示
    @x_cate = @dates.inject([]) { |r, v| r << v.strftime("%Y-%m") } if %w[month6 year].include?(params[:statistics_days])
    @series_data = @dates.inject([]) { |r, v| r << (@date_statistics.find{ |x| x.group_date.to_date == v }.try(:amount_sum).presence || 0) }
    # @x_cate = ['2-12', '2-13', '2-14', '2-15', '2-16', '2-17', '2-18']
    # @series_data = [0, 600, 300, 134, 90, 230, 200]
    # 统计销售总额 销售总额-退款总额
    @sales_total = @order_statistics.where(created_at: (@start_day..@end_day)).sum(:amount) - @refund_statistics.where(created_at: (@start_day..@end_day)).sum(:amount)
    # 统计 预计销售收入额 销售收入增加-销售收入减少
    @profit_total = @order_statistics.includes(:product).where(created_at: (@start_day..@end_day)).map(&:profit_amount).sum - @refund_statistics.includes(:product).where(created_at: (@start_day..@end_day)).map(&:profit_amount).sum
  end

  private

  def find_workstation
    @workstation = Workstation.find(params[:id])
  end

  def workstation_params
    params.require(:workstation).permit!
  end
end
