require_dependency "payment/application_controller"

module Payment
  class Station::WorkstationsController < Station::BaseController
    before_action :set_cash_account

    def cash
      earning_records
    end

    def earning_records
      @earning_records = @cash_account.earning_records.paginate(page: params[:page])
      @earning_records = query_by_date(@earning_records)
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
      chain = chain.where("created_at > ?", params[:start_date].to_date) if params[:start_date].present?
      chain = chain.where("created_at <= ?", params[:end_date].to_date + 1) if params[:end_date].present?
      chain
    rescue
      chain
    end
  end
end
