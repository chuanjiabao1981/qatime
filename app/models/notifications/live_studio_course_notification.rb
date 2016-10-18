class LiveStudioCourseNotification < ::Notification
  ACTION_ASSIGN = :assign
  ACTION_START = :start
  ACTION_NOTICE_CREATE = :notice_create # 辅导班发布公告
  ACTION_NOTICE_UPDATE = :notice_create # 辅导班修改公告

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}",
           course_name: notificationable.name,
           day: notificationable.class_date,
           announcement: notificationable.announcement,
           teacher_name: operator.try(:name)
          )
  end
end
