class LiveStudioGroupNotification < ::Notification
  ACTION_ASSIGN = :assign
  ACTION_START = :start
  ACTION_NOTICE_CREATE = :notice_create # 发布公告
  ACTION_NOTICE_UPDATE = :notice_update # 修改公告

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}",
           course_name: notificationable.name,
           day: notificationable.try(:start_at).try(:to_date),
           announcement: notificationable.announcement,
           content: notificationable.try(:announcements).try(:lastest).try(:first).try(:content),
           teacher_name: notificationable.try(:teacher).try(:name)
    )
  end

  def link
    "#{LiveStudio::CustomizedGroup.model_name.i18n_key}:#{notificationable.id}"
  end
end
