class Wap::LiveStudio::OrdersController < Wap::ApplicationController
  before_action :set_course
  def new
    # 优惠码
    @coupon = Payment::Coupon.find_by(code: params[:coupon_code]) if params[:coupon_code].present?
    @order = Payment::Order.new(product: @course, pay_type: nil, coupon: @coupon, coupon_code: @coupon.try(:code))
    @course = @order.product
  end

  def create
    # 用户之前的未支付订单 更新为无效订单
    waste_orders = Payment::Order.where(user: current_user, status: 0, product: @course)
    waste_orders.update_all(status: 99) if waste_orders.present?
    @order = Payment::Order.new(order_params.merge(user: current_user,
                                                   remote_ip: request.remote_ip,
                                                   source: 'wap',
                                                   openid: @openid))
    @coupon = Payment::Coupon.find_by(code: @order.coupon_code) if @order.coupon_code.present?
    @order.amount = @course.coupon_price(@coupon)
    if @order.save
      redirect_to wap_payment_order_path(@order.transaction_no)
    else
      p @order.errors
      render :new
    end
  end

  private

  def set_course
    @course = LiveStudio::Course.find(params[:course_id])
  end

  def order_params
    @course.order_params.merge(params.require(:order).permit(:pay_type, :coupon_code))
  end
end
