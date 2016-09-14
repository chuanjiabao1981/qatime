class LiveStudioCourseNotification < ::Notification
  ACTION_ASSIGN = :assign
  ACTION_START = :start

  ACTION_IMAGES = {
    assign: "course_create.jpg",
    start: "course_teaching.jpg"
  }.freeze

  # 通知显示logo
  def logo_image
    LiveStudioCourseNotification::ACTION_IMAGES[action_name.to_sym]
  end
end
