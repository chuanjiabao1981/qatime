class Notification < ActiveRecord::Base
  scope :unread, -> { where(read: false) }

  belongs_to :receiver, class_name: User
  belongs_to :from, polymorphic: true
  belongs_to :notificationable, polymorphic: true
  belongs_to :operator, class_name: User

  self.per_page = 20

  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}", notificationable: notificationable)
  end

  # 目前只支持辅导班
  # 如果需要支持其它类型的通知需要使用key区分setting
  # 放到子类发送
  def notify_by(_channel)
    # send("notify_by_#{channel}")
  end

  # 跳转路径，客户端用于识别跳转路径
  def link
  end

  def read!
    self.read = true
    save
  end

  # 目前只用于标题样式显示
  def notify_type
  end

  private

  def notify_by_email
    EmailWorker.perform_async(EmailWorker::LIVE_STUDIO_LESSON_START_NOTIFICATION, email: receiver.email, id: id) if receiver.email
  end

  def notify_by_message
    SmsWorker.perform_async(SmsWorker::LIVE_STUDIO_LESSON_START_NOTIFICATION, mobile: receiver.login_mobile, id: id)
  end
end
