class Wap::LiveStudio::OrdersController < Wap::ApplicationController
  before_action :set_product
  def new
    # 优惠码
    @coupon = Payment::Coupon.find_by(code: params[:coupon_code]) if params[:coupon_code].present?
    @order = Payment::Order.new(product: @product, pay_type: nil, coupon: @coupon, coupon_code: @coupon.try(:code))
  end

  def create
    # 用户之前的未支付订单 更新为无效订单
    waste_orders = Payment::Order.where(user: current_user, status: 0, product: @product)
    waste_orders.update_all(status: 99) if waste_orders.present?
    @order = Payment::Order.new(order_params.merge(user: current_user,
                                                   remote_ip: request.remote_ip,
                                                   source: 'wap',
                                                   openid: @openid))
    @coupon = Payment::Coupon.find_by(code: @order.coupon_code) if @order.coupon_code.present?
    @order.amount = @product.coupon_price(@coupon)
    if @order.save
      redirect_to wap_payment_order_path(@order.transaction_no)
    else
      render :new
    end
  end

  private

  def set_product
    @product =
      if params[:course_id].present?
        LiveStudio::Course.find(params[:course_id])
      elsif params[:video_course_id].present?
        LiveStudio::VideoCourse.find(params[:video_course_id])
      end
  end

  def order_params
    @product.order_params.merge(params.require(:order).permit(:pay_type, :coupon_code))
  end
end
