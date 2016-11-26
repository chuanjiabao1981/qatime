module Entities
  class CourseRealtime < Grape::Entity
    expose :announcements, using: Entities::LiveStudio::Announcement
    expose :members, using: Entities::Chat::Account
    expose :current_lesson_status
  end
end
