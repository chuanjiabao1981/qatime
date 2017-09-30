require_dependency "payment/application_controller"

module Payment
  class Admin::OrdersController < Admin::BaseController
    def index
      @orders = Payment::Order.includes(:user)
      @orders = @orders.where(status: Payment::Order.statuses[params[:status]]) if params[:status].present?
      @orders = @orders.order(id: :desc).paginate(page: params[:page])
    end

    def pay_for_free
      @order = Payment::Order.find_by!(transaction_no: params[:id])
      if @order.pay_for_free!
        redirect_to payment.admin_orders_path, notice: '订单支付成功.'
      else
        redirect_to payment.admin_orders_path, notice: '订单支付失败.'
      end
    end
  end
end
