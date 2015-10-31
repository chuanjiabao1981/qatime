class ActionNotification < Notification
  scope :unread, -> { where(read: false) }

  belongs_to :notificationable, polymorphic: true
  belongs_to :operator,class_name: User
end