class NotificationsController < ApplicationController
  def show
    #默认都是action notification
    if not @notification.read and @notification.receiver_id == current_user.id
      @notification.read = true
      @notification.save
    end
    begin
      # 可以重定向到customized_course_action_record_path 然后再次重定向，不过这样重定向次数太多
      redirect_to send "#{@notification.notificationable.actionable.model_name.singular_route_key}_path",@notification.notificationable.actionable
    rescue
      redirect_to user_home_path
    end
  end
  private
  def current_resource
    @notification = Notification.find(params[:id])
  end
end
