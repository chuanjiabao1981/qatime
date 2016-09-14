class Notification < ActiveRecord::Base
  scope :unread, -> { where(read: false) }

  belongs_to :receiver, class_name: User
  belongs_to :from, polymorphic: true
  belongs_to :notificationable, polymorphic: true

  self.per_page = 20
end
