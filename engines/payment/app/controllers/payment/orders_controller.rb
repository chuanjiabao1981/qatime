require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :notify
    before_action :set_user, only: [:index, :pay, :cancel_order, :show, :result, :refund, :refund_create, :cancel_refund]
    layout :layout_no_nav

    def index
      @orders = LiveService::OrderDirector.orders_for_user_index(@user,filter_patams).order(id: :desc).paginate(page: params[:page])
      render layout: 'v1/home'
    end

    # 生成微信支付二维码
    def pay
      @order = @user.orders.find_by!(transaction_no: params[:id])
      @order.init_order_for_test if Rails.env.test?
      @product = @order.product
    end

    def refund
      @order = @user.orders.find_by!(transaction_no: params[:id])
      @consumed_amount = LiveService::OrderDirector.new(@order).consumed_amount
    end

    def refund_create
      @order = @user.orders.find_by!(transaction_no: params[:id])
      @refund = LiveService::OrderDirector.new(@order).refund!
      if @refund.errors.any?
        render :refund, layout: 'payment/layouts/payment'
      else
        @refund.create_refund_reason(reason: params[:reason])
        redirect_to payment.user_orders_path(@user), notice: i18n_notice('created', @refund)
      end
    end

    def cancel_refund
      @refund = Payment::Refund.where(transaction_no: params[:id]).init.first
      @refund.cancel!
      redirect_to payment.user_orders_path(@user), notice: i18n_notice('cancel', @refund)
    end

    def cancel_order
      @order = @user.orders.find_by!(transaction_no: params[:id])
      if @order.canceled!
        redirect_to user_order_path(@user, @order.transaction_no), notice: t("flash.notice.canel_order_success") if params[:cate] == "show"
        redirect_to user_orders_path(@user, cate: :unpaid), notice: t("flash.notice.canel_order_success") if params[:cate] == "index"
      else
        redirect_to user_order_path(@user, @order.transaction_no), alert: t("flash.alert.canel_order_failed")
      end
    end

    def show
      @order = @user.orders.find_by!(transaction_no: params[:id])
      @course = @order.product
    end

    # 支付通知
    def notify
      flag = true
      begin
        @result = Hash.from_xml(request.body.read)["xml"]
        flag = WxPay::Sign.verify?(@result)
      rescue Exception => e
        logger.error '===== NOTIFY ERROR INFO START ====='
        logger.error e.message
        logger.error @result
        logger.error '===== NOTIFY ERROR INFO END ====='
        flag = false
      end
      if flag
        @order = Order.find_by(transaction_no: @result['out_trade_no'])
        @order.pay_and_ship! if @order.unpaid?
        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
      end
    end

    # 支付结果
    def result
      @order = @user.orders.find_by(transaction_no: params[:transaction_no])
      render text: @order.status
    end

    private

    def set_user
      @user = if params[:user_id]
                Student.find(params[:user_id])
              else
                Order.find_by!(transaction_no: params[:id]).user
              end
      @student = @user
      @owner = @student
    end

    def layout_no_nav
      no_nav_arys = %w(show refund)
      if @student
        no_nav_arys.include?(action_name) ? 'payment/layouts/payment' : 'student_home_new'
      else
        "payment/layouts/#{no_nav_arys.include?(action_name) ? 'payment' : 'application'}"
      end
    end

    def filter_patams
      # 使用状态查询
      params[:cate] ||= 'unpaid'
      @filter_patams = params.slice(:cate)
    end
  end
end
