class LiveStudioCourseNotification < ::Notification
  ACTION_IMAGES = {
    assign: "course_create.jpg"
  }.freeze

  # 通知显示logo
  def logo_image
    LiveStudioCourseNotification::ACTION_IMAGES[action_name.to_sym]
  end
end
