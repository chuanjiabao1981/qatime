require_dependency "payment/application_controller"

module Payment
  class WithdrawsController < ApplicationController
    before_action :set_resource_user
    layout 'payment'

    # GET /recharges/new
    def new
      @withdraw = Payment::Withdraw.new(pay_type: :wechat)
      @withdraw.wechat_user = @resource_user.wechat_users.last

      render layout: 'application_front'
    end

    # POST /recharges
    def create
      @withdraw = @resource_user.payment_withdraws.new(withdraw_params.merge(status: :init))
      if @withdraw.save
        redirect_to action: :complete, transaction: @withdraw.transaction_no
      else
        @withdraw.wechat_user = @resource_user.wechat_users.last
        render :new, layout: 'application_front'
      end
    end

    def complete
      @withdraw = Payment::Withdraw.find_by!(transaction_no: params[:transaction])
      render layout: 'application_front'
    end

    def cancel
      @withdraw = Payment::Withdraw.find params[:id]
      @withdraw.cancel!
      redirect_to cash_user_path(@resource_user),notice: i18n_notice('cancel',@withdraw)
    end

    private

    def withdraw_params
      params.require(:withdraw).permit(:amount, :pay_type, :payment_password, :wechat_user_id)
    end

    def withdraw_record_params
      {
        account: account_params["#{withdraw_params[:pay_type]}_account".to_sym],
        name: account_params["#{withdraw_params[:pay_type]}_name".to_sym]
      }
    end

    def account_params
      case withdraw_params[:pay_type]
        when 'bank'
          params.permit(:bank_account, :bank_name)
        when 'alipay'
          params.permit(:alipay_account, :alipay_name)
      end
    end

    def set_resource_user
      @resource_user ||= User.find(params[:user_id])
      @cash_account = @resource_user.cash_account
      @resource_owner = @resource_user
    end

    def current_resource
      @current_resource ||= set_resource_user
    end
  end
end
