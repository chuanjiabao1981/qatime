class Notification < ActiveRecord::Base
  scope :unread, -> { where(read: false) }

  belongs_to :receiver, class_name: User
  belongs_to :from, polymorphic: true
  belongs_to :notificationable, polymorphic: true
  belongs_to :operator, class_name: User

  self.per_page = 20

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}", notificationable: notificationable)
  end
end
