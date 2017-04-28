class NotificationsController < ApplicationController
  before_action :load_user, only: [:index]
  before_action :load_notification, only: [:show]

  def index
    @notifications = @receiver.notifications.includes([:notificationable, :from]).paginate(page: params[:page])
  end

  def show
    # 默认都是action notification
    if !@notification.read && @notification.receiver_id == current_user.id
      @notification.read = true
      @notification.save
    end
    redirect_to(params[:rt] || user_home_path)
  rescue
    redirect_to user_home_path
  end

  private

  def load_user
    @receiver ||= User.find(params[:user_id])
    @owner = @receiver
  end

  def load_notification
    @notification ||= Notification.find(params[:id])
  end

  def current_resource
    params[:user_id].present? ? load_user : load_notification
  end

  def current_user_layout
    return 'v1/home' if @owner.student? || @owner.teacher?
    super
  end
end
