class Notification < ActiveRecord::Base
  belongs_to :receiver,class_name: User

  self.per_page = 10
end
