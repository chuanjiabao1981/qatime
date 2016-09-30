require_dependency "payment/application_controller"

module Payment
  class WithdrawsController < ApplicationController
    before_action :set_resource_user

    # GET /recharges/new
    def new
      @cash_account = @resource_user.cash_account
      @recharge = Payment::Withdraw.new
      render :new, layout: 'payment'
    end

    # POST /recharges
    def create
      #
    end


    private

    def set_resource_user
      @resource_user ||= if params[:user_id]
                           User.find(params[:user_id])
                         else
                           set_recharge.user
                         end
      @resource_owner = @resource_user
    end

    def current_resource
      @current_resource ||= set_resource_user
    end
  end
end
