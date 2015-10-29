class Notification < ActiveRecord::Base
  belongs_to :receiver,class_name: User
end
