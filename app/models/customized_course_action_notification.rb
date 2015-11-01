class CustomizedCourseActionNotification < Notification
  belongs_to :operator,class_name: User
  belongs_to :notificationable, polymorphic: true
  belongs_to :customized_course
end