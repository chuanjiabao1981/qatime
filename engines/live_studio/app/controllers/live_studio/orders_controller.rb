require_dependency "live_studio/application_controller"

module LiveStudio
  class OrdersController < ApplicationController
    layout 'v1/application'
    skip_before_action :authorize, only: [:check_coupon]

    before_action :set_order, only: [:show, :edit, :update, :destroy]
    before_action :set_product, except: [:check_coupon]
    before_action :find_coupon, only: [:create, :check_coupon]
    before_action :detect_device_format, only: [:new, :create]

    # GET /orders/1
    def show
    end

    # GET /orders/new
    def new
      @order = Payment::Order.new(product: @product, pay_type: nil)

      respond_to do |format|
        format.html do |html|
          html.none
          html.tablet
          html.phone { render layout: 'application-mobile' }
        end
      end
    end

    # POST /orders
    def create
      # 用户之前的未支付订单 更新为无效订单
      waste_orders = Payment::Order.where(user: current_user, status: 0, product: @product)
      waste_orders.update_all(status: 99) if waste_orders.present?
      buy_params = @product.order_params.merge(order_params)
      @order = Payment::Order.new(buy_params.merge(user: current_user, remote_ip: request.remote_ip, source: order_source))
      @order.coupon_code = params[:coupon_code].presence

      # 使用优惠码
      if @coupon.present?
        @order.coupon_id = @coupon.id
        @order.amount = @product.coupon_price(@coupon)
      end

      if @order.save
        flash_msg(:success, '下单成功!')
        redirect_to payment.transaction_path(@order.transaction_no)
      else
        respond_to do |format|
          format.html do |html|
            html.none { render :new }
            html.tablet
            html.phone { render :new, layout: 'application-mobile' }
          end
        end
      end
    end

    def pay
    end

    # ajax 校验优惠码 return json
    def check_coupon
      if @coupon.present?
        render json: {success: true, price: @coupon.price.to_f}
      else
        render json: {success: false}
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product =
          if params[:course_id].present?
            Course.find_by(id: params[:course_id])
          elsif params[:interactive_course_id].present?
            InteractiveCourse.find(params[:interactive_course_id])
          else
            VideoCourse.find(params[:video_course_id])
          end
      end

      def set_order
        @order = Payment::Order.find_by(id: params[:id])
      end

      def find_coupon
        @coupon = ::Payment::Coupon.find_by(code: params[:coupon_code])
      end

      # Only allow a trusted parameter "white list" through.
      def order_params
        params.require(:order).permit(:pay_type, :payment_password)
      end

      def order_source
        request.variant ? 'wap' : 'web'
      end
  end
end
