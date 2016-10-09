class Notification < ActiveRecord::Base
  scope :unread, -> { where(read: false) }

  belongs_to :receiver,class_name: User

  self.per_page = 20
end
