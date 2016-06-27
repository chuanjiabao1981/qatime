require_dependency "payment/application_controller"

module Payment
  class OrdersController < ApplicationController
    def show
      @order = Order.find_by!(order_no: params[:id])
    end
  end
end
