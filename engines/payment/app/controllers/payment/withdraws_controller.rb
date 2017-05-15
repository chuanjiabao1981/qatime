require_dependency "payment/application_controller"

module Payment
  class WithdrawsController < ApplicationController
    before_action :set_resource_user
    layout 'v1/application'

    # GET /recharges/new
    def new
      @withdraw = Payment::Withdraw.new(pay_type: :alipay)
    end

    # POST /recharges
    def create
      @errors = []
      # captcha_manager = UserService::CaptchaManager.new(@resource_user.login_mobile)
      # captcha = captcha_manager.captcha_of(:withdraw_cash)
      # @errors << t('view.verify_error') if params[:verify] != captcha
      @errors << t('view.withdraw.wait_audit') if @resource_user.payment_withdraws.init.present?
      @errors << t("error.payment/order.payment_password_min") if withdraw_params[:amount].to_f < 1

      cash_account = @resource_user.cash_account!
      if params[:payment_password].blank?
        @errors << I18n.t("error.payment/order.payment_password_blank")
      elsif cash_account.password_set_at.blank?
        @errors << I18n.t("error.payment/order.payment_password_unset")
      elsif cash_account.password_set_at > 2.hours.ago
        @errors << t("error.payment/order.payment_password_young")
      elsif !cash_account.authenticate(params[:payment_password])
        @errors << I18n.t("error.payment/order.payment_password_invalid")
      end

      @withdraw = @resource_user.payment_withdraws.new(withdraw_params.merge(status: :init))
      if @errors.blank?
        if @withdraw.save
          @withdraw.create_withdraw_record!(withdraw_record_params) unless @withdraw.cash?
          redirect_to action: :complete, transaction: @withdraw.transaction_no
        else
          @errors += @withdraw.errors.messages.values.flatten
          render :new
        end
      else
        render :new
      end
    end

    def complete
      @withdraw = Payment::Withdraw.find_by!(transaction_no: params[:transaction])
    end

    def cancel
      @withdraw = Payment::Withdraw.find params[:id]
      @withdraw.cancel!
      redirect_to cash_user_path(@resource_user),notice: i18n_notice('cancel',@withdraw)
    end

    private
    def withdraw_params
      params.require(:withdraw).permit(:amount, :pay_type)
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
          params.permit(:bank_account,:bank_name)
        when 'alipay'
          params.permit(:alipay_account,:alipay_name)
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
