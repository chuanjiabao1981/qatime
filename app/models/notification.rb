class Notification < ActiveRecord::Base
  scope :unread, -> { where(read: false) }

  belongs_to :receiver, class_name: User
  belongs_to :from, polymorphic: true
  belongs_to :notificationable, polymorphic: true

  self.per_page = 20

  # 目前只支持辅导班
  # 如果需要支持其它类型的通知需要使用key区分setting
  def notify_by(channel)
    send("notify_by_#{channel}")
  end

  private

  def notify_by_email
    SmsWorker.perform_async(SmsWorker::LIVE_STUDIO_LESSON_START_NOTIFICATION, id: id)
  end

  def notify_by_message
    SmsWorker.perform_async(SmsWorker::LIVE_STUDIO_LESSON_START_NOTIFICATION, id: id)
  end
end
