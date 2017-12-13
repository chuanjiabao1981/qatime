require_dependency "exam/application_controller"

module Exam
  class OrdersController < ApplicationController
    before_action :set_product

    layout 'v2/application'

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
      buy_params = @product.order_params.merge(order_params)
      @order = Payment::Order.new(buy_params.merge(user: current_user, remote_ip: request.remote_ip, source: order_source))

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

    private

    def set_product
      @product = Exam::Paper.find(params[:paper_id])
    end

    def set_order
      @order = Payment::Order.find_by(id: params[:id])
    end

    def find_coupon
      @coupon = ::Payment::Coupon.find_by(code: params[:coupon_code])
    end

    def order_params
      params.require(:order).permit(:pay_type, :payment_password)
    end

    def order_source
      request.variant ? 'wap' : 'web'
    end

    # 检查课程是否下架
    def check_product_for_sell
      return unless @product.off_shelve?
      redirect_to live_studio.send("#{@product.model_name.singular_route_key}_path", @product), notice: t('common.off_shelve')
    end

    # 免费课程跳过下单直接发票
    def check_free_product
      return false if @product.is_a?(LiveStudio::InteractiveCourse)
      return false unless @product.sell_type.free?
      redirect_to live_studio.deliver_video_course_path(@product) if @product.is_a?(LiveStudio::VideoCourse)
      redirect_to live_studio.for_free_course_path(@product) if @product.is_a?(LiveStudio::Course)
      redirect_to live_studio.for_free_customized_group_path(@product) if @product.is_a?(LiveStudio::CustomizedGroup)
    end
  end
end
