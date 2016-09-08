module LiveStudio
  class CourseActionNotification < ::Notification
    belongs_to :operator, class_name: '::User'
    belongs_to :notificationable, polymorphic: true
    belongs_to :course
  end
end
