class NotificationsController < ApplicationController
  def show
    #默认都是action notification
    if not @notification.read and @notification.receiver_id == current_user.id
      @notification.read = true
      @notification.save
    end
    redirect_to send "#{@notification.notificationable.model_name.singular_route_key}_path",@notification.notificationable
  end
  private
  def current_resource
    @notification = Notification.find(params[:id])
  end
end
