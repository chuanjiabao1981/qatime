module Entities
  module LiveStudio
    class TodayFullLesson < Grape::Entity
      expose :lesson_type do |lesson|
        lesson.model_name
      end
      expose :lesson, merge: true, if: lambda { |object, options| object.is_a?(::LiveStudio::Lesson) } do |instance, options|
        ::Entities::LiveStudio::TodayLesson.represent instance
      end
      expose :scheduled_lesson, merge: true, if: lambda { |object, options| object.is_a?(::LiveStudio::ScheduledLesson) } do |instance, options|
        ::Entities::LiveStudio::TodayScheduledLesson.represent instance
      end
    end
  end
end
