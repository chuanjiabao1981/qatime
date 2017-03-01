class Wap::LiveStudio::OrdersController < Wap::ApplicationController
  before_action :set_course
  def new
    # 优惠码
    @coupon = Payment::Coupon.find_by(code: params[:coupon_code]) if params[:coupon_code].present?
    @order = Payment::Order.new(product: @course, pay_type: nil, coupon: @coupon)
    @course = @order.product
  end

  def create
    @order = Payment::Order.new(order_params.merge(user: current_user,
                                                   remote_ip: request.remote_ip,
                                                   source: 'wap',
                                                   openid: @openid))
    if @order.save
      redirect_to wap_payment_order_path(@order.transaction_no)
    else
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
