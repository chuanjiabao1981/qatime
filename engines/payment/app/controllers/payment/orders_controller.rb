require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :notify
    before_action :set_student, skip: [:notify]

    def index
      @orders = current_user.orders.paginate(page: params[:page])
    end

    # 生成微信支付二维码
    def show
      @order = current_user.orders.find_by!(order_no: params[:id])

      r = WxPay::Service.invoke_unifiedorder order_params

      if r['code_url'].is_a? String
        @qrcode_url = Qr_Code.generate_payment(@order.id, r['code_url'])
      else
        @order.trash!
        redirect_to live_studio.courses_path, notice: '二维码生成失败，请稍后重试'
      end
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

    def order_params
      {
          body: "购买辅导班：#{@order.product.name}",
          out_trade_no: @order.order_no,
          total_fee: @order.pay_money,
          spbill_create_ip: request.env['REMOTE_ADDR'],
          notify_url:  "#{WECHAT_CONFIG['domain_name']}/payment/notify",
          trade_type: 'NATIVE',
          fee_type: 'CNY'
      }
    end
  end
end
