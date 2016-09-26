require_dependency "payment/application_controller"

module Payment
  class UsersController < ApplicationController
    def cash
      @cash_account = @current_resource.cash_account!
      if @current_resource.student?
        @student = @current_resource
        if params[:fee].nil?
          @recharges = @current_resource.payment_recharges.order(created_at: :desc).paginate(page: params[:page])
        else
          @consumption_records = @current_resource.cash_account.consumption_records.includes(:target).order(created_at: :desc).paginate(page: params[:page])
        end
      elsif @current_resource.teacher?
        @teacher = @current_resource
        if params[:fee].nil?
          @withdraws = @teacher.payment_withdraws.order(created_at: :desc).paginate(page: params[:page],:per_page => 20)
        else
          @earning_records = @current_resource.cash_account.earning_records.includes(:target).order(created_at: :desc).paginate(page: params[:page])
        end
      end

      # @change_records = @current_resource.cash_account!.change_records.includes(billing: :target).paginate(page: params[:page])
    end

    private

    def current_resource
      @current_resource ||= User.find(params[:id])
    end
  end
end
