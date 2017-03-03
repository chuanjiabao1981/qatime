class Wap::Payment::OrdersController < Wap::ApplicationController
  before_action :set_order

  def show
    @pay_params = @order.remote_order.try(:wap_pay_params)
  end

  def pay
    @order.assign_attributes(pay_params)
    if @order.pay_with_payment_password!
      redirect_to action: :show
    else
      render :show
    end
  end

  private

  def set_order
    @order = Payment::Order.find_by!(transaction_no: params[:id])
  end

  def pay_params
    params.require(:order).permit(:payment_password)
  end
end
