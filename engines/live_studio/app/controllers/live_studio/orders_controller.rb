require_dependency "live_studio/application_controller"

module LiveStudio
  class OrdersController < ApplicationController
    layout 'application_front'

    before_action :set_order, only: [:show, :edit, :update, :destroy]
    before_action :set_course

    # GET /orders/1
    def show
    end

    # GET /orders/new
    def new
      @order = Payment::Order.new(product: @course, pay_type: nil)
    end

    # GET /orders/1/edit
    def edit
    end

    # POST /orders
    def create
      # 用户之前的未支付订单 更新为无效订单
      waste_orders = Payment::Order.where(user: current_user, status: 0, product: @course)
      waste_orders.update_all(status: 99) if waste_orders.present?
      buy_params = @course.order_params.merge(order_params)
      @order = Payment::Order.new(buy_params.merge(user: current_user,
                                                   remote_ip: request.remote_ip))
      if @order.save
        redirect_to payment.transaction_path(@order.transaction_no)
      else
        render :new
      end
    end

    def pay
    end

    # PATCH/PUT /orders/1
    def update
      if @order.update(order_params)
        redirect_to @order, notice: i18n_notice('updated', @order)
      else
        render :edit
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_course
        @course = Course.find(params[:course_id])
      end

      def set_order
        @order = Payment::Order.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def order_params
        params.require(:order).permit(:pay_type, :payment_password)#
      end
  end
end
