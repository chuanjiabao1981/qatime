require_dependency "payment/application_controller"

module Payment
  class TransactionsController < ApplicationController
    layout 'v1/application'

    skip_before_action :verify_authenticity_token, only: :notify

    before_action :set_transaction
    before_action :detect_device_format, only: [:show]
    before_action :check_order, only: [:show]

    def show
      respond_to do |format|
        format.html do |html|
          html.none
          html.tablet
          html.phone { render layout: 'application-mobile' }
        end
      end
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
      if params[:method] == "alipay.trade.page.pay.return"
        proccess_result
        if @transaction.is_a? Payment::Recharge
          redirect_to payment.cash_user_path(@transaction.user)
        elsif @transaction.product.is_a? LiveStudio::InteractiveCourse
          redirect_to live_studio.interactive_course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
        elsif @transaction.product.is_a? LiveStudio::VideoCourse
          redirect_to live_studio.video_course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
        elsif @transaction.product.is_a? LiveStudio::CustomizedGroup
          redirect_to live_studio.customized_group_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
        else
          redirect_to live_studio.course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
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
        render 'show'
      elsif @transaction.is_a? Payment::Recharge
        redirect_to payment.cash_user_path(@transaction.user)
      elsif @transaction.product.is_a?(LiveStudio::InteractiveCourse)
        redirect_to live_studio.interactive_course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
      elsif @transaction.product.is_a?(LiveStudio::VideoCourse)
        redirect_to live_studio.video_course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
      elsif @transaction.product.is_a?(LiveStudio::CustomizedGroup)
        redirect_to live_studio.customized_group_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
      else
        redirect_to live_studio.course_path(@transaction.product), notice: I18n.t('view.payment/transaction.pay_success')
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
      @transaction.remote_order.proccess_notify(notify_params(@transaction.pay_type))
    end

    def proccess_result
      return false unless @transaction.remote_order
      result_params = alipay_params
      @transaction.remote_order.proccess_result(result_params) if result_params.present?
    end

    def notify_params(pay_type)
      send("#{pay_type}_params")
    rescue
      {}
    end

    def weixin_params
      Hash.from_xml(request.body.read)["xml"]
    end

    def alipay_params
      params.except(*request.path_parameters.keys)
    end

    def check_order
      return if @transaction.remote_order
      if @transaction.source.wap? && @transaction.pay_type.weixin?
        wechat_openid
        @transaction.openid = @openid
        @transaction.save && @transaction.instance_remote_order!
      end
    end

    def wechat_openid
      cookies[:openid] ||= "testopenid" if Rails.env.test?
      if cookies[:openid].blank?
        session[:return_to] = request.original_url
        redirect_to "#{WECHAT_CONFIG['host']}/auth/wechat2"
      end
      @openid = cookies[:openid]
    end
  end
end
