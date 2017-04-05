require_dependency "payment/application_controller"

module Payment
  class TransactionsController < ApplicationController
    layout 'payment'

    skip_before_action :verify_authenticity_token, only: :notify

    before_action :set_transaction

    def show
      render layout: 'application_front'
    end

    def notify
      proccess_notify
      if !@transaction.remote_order.paid?
        render text: 'fail'
      elsif @transaction.pay_type.weixin?
        render xml: { return_code: "SUCCESS" }.to_xml(root: 'xml', dasherize: false)
      elsif @transaction.pay_type.alipay?
        render text: 'success'
      else
        render text: "unknown notify"
      end
    end

    def result
      # 支付宝结果回调
      if params[:notify_type] == "trade_status_sync"
        proccess_result
        if @transaction.is_a? Payment::Recharge
          redirect_to payment.cash_user_path(@transaction.user)
        elsif @transaction.product.is_a? LiveStudio::InteractiveCourse
          redirect_to live_studio.student_interactive_courses_path(@transaction.user)
        else
          redirect_to live_studio.student_courses_path(@transaction.user)
        end
      end
    end

    # 确认支付
    def pay
      cash_account = current_user.cash_account!

      if params[:payment_password].blank?
        @error = '支付密码不能为空'
      elsif cash_account.password_set_at.blank?
        @error = "支付密码未设置"
      elsif cash_account.password_set_at > 24.hours.ago
        @error = '修改或者设置支付密码24小时内不可用'
      elsif !cash_account.authenticate(params[:payment_password])
        @error = "支付密码验证失败"
      end
      @ticket_token = ::TicketToken.instance_token(@transaction, :pay) if @error.nil?
      begin
        @transaction.pay_with_ticket_token!(@ticket_token) if @error.nil? && @transaction.account?
      rescue ::Payment::BalanceNotEnough
        @error = "余额不足"
      rescue ::Payment::TokenInvalid
        puts @error
      end
      if(@error)
        render 'show', layout: 'application_front'
      elsif @transaction.is_a? Payment::Recharge
        redirect_to payment.cash_user_path(@transaction.user)
      elsif @transaction.product.is_a?(LiveStudio::InteractiveCourse)
        redirect_to live_studio.student_interactive_courses_path(@transaction.user)
      else
        redirect_to live_studio.student_courses_path(@transaction.user)
      end
    end

    private

    def set_transaction
      @transaction ||= Transaction.find_by!(transaction_no: params[:id])
    end

    def current_resource
      @current_resource ||= set_transaction.user
    end

    def proccess_notify
      return false unless @transaction.remote_order
      notify_params = if @transaction.pay_type.alipay?
                        alipay_params
                      elsif @transaction.pay_type.weixin?
                        weixin_params
                      end
      @transaction.remote_order.proccess_notify(notify_params) if notify_params.present?
    end

    def proccess_result
      return false unless @transaction.remote_order
      result_params = alipay_params
      @transaction.remote_order.proccess_result(result_params) if result_params.present?
    end

    def weixin_params
      Hash.from_xml(request.body.read)["xml"]
    end

    def alipay_params
      params.except(*request.path_parameters.keys)
    end
  end
end
