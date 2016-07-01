require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :notify
    before_action :set_student, skip: [:notify]
    layout :layout_no_nav

    def index
      @orders = current_user.orders.order(id: :desc).paginate(page: params[:page])
    end

    # 生成微信支付二维码
    def show

      @order = current_user.orders.find_by!(order_no: params[:id])
      @order.init_remote_order unless @order.qrcode_url
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
        @order = Order.find_by(order_no: @result['out_trade_no'])
        @order.pay_and_ship! if @order.unpaid?
        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
      end
    end

    # 支付结果
    def result
      @order = @student.orders.find_by(order_no: params[:order_no])
      render text: @order.status
    end

    private

    def set_student
      @student = current_user
    end

    def layout_no_nav
      no_nav_arys = %w(show)
      "payment/layouts/#{no_nav_arys.include?(action_name) ? 'payment' : 'application'}"
    end
  end
end
