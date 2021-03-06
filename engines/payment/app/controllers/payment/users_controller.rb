require_dependency "payment/application_controller"

module Payment
  class UsersController < ApplicationController
    layout 'v1/home'

    before_action :set_cash_account

    # 资金
    def cash
      redirect_to action: :earning_records if @current_resource.teacher?
      redirect_to action: :recharges if @current_resource.student?
    end

    # 充值记录
    def recharges
      @recharges = query_by_date(@current_resource.payment_recharges)
      @recharges = @recharges.order(created_at: :desc).paginate(page: params[:page])
    end

    # 提现记录
    def withdraws
      @withdraws = query_by_date(@current_resource.payment_withdraws)
      @withdraws = @withdraws.order(created_at: :desc).paginate(page: params[:page])
    end

    # 消费记录
    def consumption_records
      @consumption_records = query_by_date(@cash_account.consumption_records.includes(:target))
      @consumption_records = @consumption_records.order(created_at: :desc).paginate(page: params[:page])
    end

    # 收入记录
    def earning_records
      @earning_records = query_by_date(@cash_account.earning_records.includes(:target))
      @earning_records = @earning_records.order(created_at: :desc).paginate(page: params[:page])
    end

    # 退款记录
    def refunds
      @refunds = query_by_date(@current_resource.payment_refunds)
      @refunds = @refunds.order(created_at: :desc).paginate(page: params[:page])
    end

    private

    def current_resource
      @current_resource ||= @owner = User.find(params[:id])
    end

    def query_by_date(chain)
      chain = chain.where("created_at > ?", params[:start_date].to_time) if params[:start_date].present?
      chain = chain.where("created_at <= ?", params[:end_date].to_time + 1.day) if params[:end_date].present?
      chain
    rescue
      chain
    end

    def set_cash_account
      @cash_account = current_resource.cash_account!
    end
  end
end
