module LiveStudio
  class CourseActionNotification < ::Notification
    belongs_to :operator, class_name: '::User'
    belongs_to :notificationable, polymorphic: true
    belongs_to :live_studio_course, class_name: '::LiveStudio::Course'
  end
end
