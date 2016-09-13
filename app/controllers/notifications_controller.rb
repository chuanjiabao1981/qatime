class NotificationsController < ApplicationController
  before_action :load_user
  before_action :load_notification, only: [:show]

  def index
    @notifications = @receiver.notifications.includes([:notificationable, :from]).paginate(page: params[:page])
  end

  def show
    # 默认都是action notification
    if not @notification.read and @notification.receiver_id == current_user.id
      @notification.read = true
      @notification.save
    end

    if current_resource.type == "LiveStudio::CourseActionNotification"
      begin
        if current_user.teacher?
          case @notification.notificationable.category.to_s.split("_").first
          when "course"
            redirect_to live_studio.teacher_course_path(current_user.id, @notification.notificationable.live_studio_course.id)
          when "lesson"
            redirect_to live_studio.teacher_course_path(current_user.id, @notification.notificationable.live_studio_course.id, index: :list)
          end
        elsif current_user.student?
          case @notification.notificationable.category.to_s.split("_").first
          when "course"
            redirect_to live_studio.student_course_path(current_user.id, @notification.notificationable.live_studio_course.id)
          when "lesson"
            redirect_to live_studio.student_course_path(current_user.id, @notification.notificationable.live_studio_course.id, index: :list)
          when "notice"
            redirect_to live_studio.play_course_path(@notification.live_studio_course)
          end
        else
          redirect_to user_home_path
        end
      rescue
        redirect_to user_home_path
      end
    else
      begin
        # 可以重定向到customized_course_action_record_path 然后再次重定向，不过这样重定向次数太多

        redirect_to send "#{@notification.notificationable.actionable.model_name.singular_route_key}_path",@notification.notificationable.actionable
      rescue
        redirect_to user_home_path
      end
    end
  end

  private

  def load_user
    @receiver ||= User.find(params[:user_id])
  end

  def load_notification
    @notification = Notification.find(params[:id])
  end

  def current_resource
    load_user
  end
end
