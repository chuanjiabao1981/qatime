class Students::OrdersController < ApplicationController
  # GET /students/orders
  # GET /students/orders.json
  def index
    @student = current_user
    @orders = current_user.orders.paginate(page: params[:page])
  end

  def pay
    @order = current_user.orders.find(params[:id])
    @order.pay_and_ship!

    respond_to do |format|
      format.html { redirect_to students_orders_path }
      format.json { head :no_content }
    end
  end
end
