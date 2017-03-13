class LiveStudioLessonNotification < ::Notification
  ACTION_START_FOR_TEACHER = :start_for_teacher
  ACTION_START_FOR_STUDENT = :start_for_student
  ACTION_MISS_FOR_TEACHER = :miss_for_teacher # 未上课通知
  ACTION_MISS_FOR_STUDENT = :miss_for_student # 未上课通知
  ACTION_CHANGE_TIME = :change_time # 调课提醒

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}",
           lesson_name: notificationable.name,
           start_time: notificationable.start_time
          )
  end

  # 目前只支持辅导班
  # 如果需要支持其它类型的通知需要使用key区分setting
  def notify_by(channel)
    return unless [ACTION_START_FOR_TEACHER, ACTION_START_FOR_STUDENT].include?(action_name.to_sym)
    send("notify_by_#{channel}")
  end

  def link
    "#{LiveStudio::Course.model_name.i18n_key}:#{notificationable.course_id}"
  end
end
