class LiveStudioLessonNotification < ::Notification
  ACTION_START_FOR_TEACHER = :start_for_teacher
  ACTION_START_FOR_STUDENT = :start_for_student

  ACTION_IMAGES = {
    start_for_teacher: "lesson_teach.jpg",
    start_for_student: "lesson_teach.jpg"
  }.freeze

  # 通知显示logo
  def logo_image
    LiveStudioLessonNotification::ACTION_IMAGES[action_name.to_sym]
  end
end
