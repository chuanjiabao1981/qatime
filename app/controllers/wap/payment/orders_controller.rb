class Wap::Payment::OrdersController < Wap::ApplicationController
  before_action :set_order

  def show
    @pay_params = @order.remote_order.try(:wap_pay_params)
  end

  private

  def set_order
    @order = Payment::Order.find_by!(transaction_no: params[:id])
  end
end
