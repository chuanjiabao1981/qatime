class NotificationsController < ApplicationController
  def show
    #默认都是action notification
    if not @notification.read and @notification.receiver_id == current_user.id
      @notification.read = true
      @notification.save
    end

    if current_resource.type == "LiveStudio::CourseActionNotification"
      begin
        if current_user.teacher?
          redirect_to live_studio.teacher_course_path(current_user.id, @notification.notificationable.live_studio_course.id)
        elsif current_user.student?
          redirect_to live_studio.student_course_path(current_user.id, @notification.notificationable.live_studio_course.id)
        else
          redirect_to user_home_path
        end
      rescue
        redirect_to user_home_path
      end
    else
      begin
        # 可以重定向到customized_course_action_record_path 然后再次重定向，不过这样重定向次数太多

        if current_resource.type == "LiveStudio::CourseActionNotification"
        end
        redirect_to send "#{@notification.notificationable.actionable.model_name.singular_route_key}_path",@notification.notificationable.actionable
      rescue
        redirect_to user_home_path
      end
    end
  end

  private

  def current_resource
    @notification = Notification.find(params[:id])
  end
end
