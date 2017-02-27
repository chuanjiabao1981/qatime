class Wap::LiveStudio::OrdersController < Wap::ApplicationController
  before_action :set_course
  def new
    @order = Payment::Order.new(product: @course, pay_type: nil)
  end

  def create
    @order = Payment::Order.new(order_params.merge(user: current_user,
                                                   remote_ip: request.remote_ip,
                                                   source: 'wap'))
    @order.save
    @pay_params = @order.remote_order.try(:app_pay_params)
  end

  private

  def set_course
    @course = LiveStudio::Course.find(params[:course_id])
  end

  def order_params
    @course.order_params.merge(params.require(:order).permit(:pay_type))
  end
end
