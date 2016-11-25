module Entities
  module LiveStudio
    class SearchCourse < Entities::LiveStudio::Course
      expose :preview_time do |course|
        lesson = course.current_lesson
        lesson.blank? ? '' : "#{lesson.class_date} #{lesson.start_time}"
      end

      expose :teacher, using: Entities::Teacher, if: { type: :full }

      expose :is_tasting do |course, options|
        course.tasting?(options[:current_user])
      end
      expose :is_bought do |course, options|
        course.bought_by?(options[:current_user])
      end
    end
  end
end
