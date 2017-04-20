class LiveStudioVideoCourseNotification < ::Notification
  ACTION_REJECT = :reject # 审核被拒
  ACTION_CONFIRM = :confirm # 审核通过
  ACTION_PUBLISH = :publish # 发布招生

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}",
           course_name: notificationable.name,
           teacher_name: notificationable.try(:teacher).try(:name))
  end

  def link
    "#{LiveStudio::VideoCourse.model_name.i18n_key}:#{notificationable.id}"
  end
end
