require_dependency "live_studio/application_controller"

module LiveStudio
  class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy]
    before_action :set_course

    # GET /orders/1
    def show
    end

    # GET /orders/new
    def new
      @order = Payment::Order.new(product: @course)
    end

    # GET /orders/1/edit
    def edit
    end

    # POST /orders
    def create
      @order = Payment::Order.new(order_params.merge(@course.order_params))
      @order.user = current_user

      if @order.save
        redirect_to course_order_path(@course, @order), notice: i18n_notice('created', @order)
      else
        render :new
      end
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
        params.require(:order).permit(:pay_type)
      end
  end
end
