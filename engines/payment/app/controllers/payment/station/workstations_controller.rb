require_dependency "payment/application_controller"

module Payment
  class Station::WorkstationsController < Station::BaseController
    before_action :set_cash_account

    def cash
      earning_records
    end

    def earning_records
      @earning_records = @cash_account.earning_records
      @earning_records = query_by_date(@earning_records)
      unless params[:q].blank?
        @from_user = User.where("login_mobile = ? or name = ?", params[:q], params[:q]).last
        @earning_records = @from_user.nil? ? @earning_records.where(id: nil) : @earning_records.where(payment_billings: { from_user_id: @from_user.id })
      end
      @amount = @earning_records.sum(:amount)
      @earning_records = @earning_records.order(id: :desc).paginate(page: params[:page])
    end

    def withdraws
      @withdraws = @cash_account.withdraw_change_records.paginate(page: params[:page])
      @withdraws = query_by_date(@withdraws)
    end

    private

    def set_cash_account
      @cash_account = @workstation.cash_account!
    end

    def set_workstation
      @workstation ||= Workstation.find(params[:id])
    end

    def query_by_date(chain)
      return chain if params[:category].blank? || 'total' == params[:category]
      start_at =
        case params[:category]
        when 'daily'
          Time.now.beginning_of_day
        when 'three_day'
          3.days.ago.beginning_of_day
        when 'weekly'
          7.days.ago.beginning_of_day
        when 'monthly'
          30.days.ago.beginning_of_day
        when 'quarterly'
          90.days.ago.beginning_of_day
        when 'half_yearly'
          180.days.ago.beginning_of_day
        when 'yearly'
          1.years.ago.beginning_of_day
        end
      chain.where("payment_change_records.created_at > ?", start_at)
    rescue
      chain
    end
  end
end
