require_dependency "payment/application_controller"

module Payment
  class UsersController < ApplicationController
    def cash
      @cash_account = @current_resource.cash_account!
      if @current_resource.student?
        @student = @current_resource
        if params[:fee] == 'y'
          @consumption_records = @current_resource.cash_account.consumption_records.includes(:target)
          @consumption_records = query_by_date(@consumption_records).order(created_at: :desc).paginate(page: params[:page])
        else
          @recharges = @current_resource.payment_recharges
          @recharges = query_by_date(@recharges).order(created_at: :desc).paginate(page: params[:page])
        end
      elsif @current_resource.teacher?
        @teacher = @current_resource
        if params[:fee] == 'y'
          @earning_records = @current_resource.cash_account.earning_records.includes(:target)
          @earning_records = query_by_date(@earning_records).order(created_at: :desc).paginate(page: params[:page])
        else
          @withdraws = @teacher.payment_withdraws.order(created_at: :desc).paginate(page: params[:page])
        end
      end

      # @change_records = @current_resource.cash_account!.change_records.includes(billing: :target).paginate(page: params[:page])
    end

    private

    def current_resource
      @current_resource ||= User.find(params[:id])
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
