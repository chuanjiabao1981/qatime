require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    before_action :set_student

    def show

      @order = current_user.orders.find_by!(order_no: params[:id])

      order_params =
          {
              body: 'test order',
              out_trade_no: @order.order_no,
              total_fee: @order.total_money.to_f,
              spbill_create_ip: request.remote_ip,
              notify_url: 'https://ulmxbgxaiu.localtunnel.me/payment/notify',
              trade_type: 'NATIVE'
          }
      r = WxPay::Service.invoke_unifiedorder order_params

      logger.info r
      logger.info "####" * 10
      logger.info

      require 'rqrcode'
      qrcode = RQRCode::QRCode.new("http://github.com/")
      # With default options specified explicitly
      png = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 120,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
      )
      @qrcode_url = "/uploads/qrcode/#{@order.id.to_s}_#{Time.now.to_i.to_s}.png"
      IO.write("public/uploads/qrcode/#{@order.id.to_s}_#{Time.now.to_i.to_s}.png", png.to_s.force_encoding('UTF-8'))
    end

    def notify

    end

    private

    def set_student
      @student = current_user
    end
  end
end
