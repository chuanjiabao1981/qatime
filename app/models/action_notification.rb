class ActionNotification < Notification
  belongs_to :notificationable, polymorphic: true
  belongs_to :operator,class_name: User
end