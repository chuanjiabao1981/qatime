class LiveStudioLessonNotification < ::Notification
  ACTION_START = :start

  ACTION_IMAGES = {
    start: ""
  }.freeze

  # 通知显示logo
  def logo_image
    LiveStudioLessonNotification::ACTION_IMAGES[action_name.to_sym]
  end
end
