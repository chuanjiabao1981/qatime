require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    before_action :set_student

    def show
      @order = current_user.orders.find_by!(order_no: params[:id])
      require 'rqrcode'

      # qrcode = RQRCode::QRCode.new("http://github.com/")
      # # With default options specified explicitly
      # png = qrcode.as_png(
      #     resize_gte_to: false,
      #     resize_exactly_to: false,
      #     fill: 'white',
      #     color: 'black',
      #     size: 120,
      #     border_modules: 4,
      #     module_px_size: 6,
      #     file: "#{Rails.root}/github-qrcode.png", # path to write
      #     encode: 'utf-8'
      # )
      # IO.write("/tmp/github-qrcode.png", png.to_s)
    end

    private

    def set_student
      @student = current_user
    end
  end
end
