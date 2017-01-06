module Entities
  module LiveStudio
    class StudentCourse < Entities::LiveStudio::Course
      expose :pull_address do |course, options|
        ticket = ::LiveStudio::Ticket.where(student: options[:current_user],course: course).authorizable.last
        ticket.present? ? course.board_pull_stream : ''
      end

      expose :board_pull_stream
      expose :camera_pull_stream

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

      expose :tasted do |course, options|
        course.tasted?(options[:current_user])
      end

      expose :current_lesson_name ,if: { type: :full } do |course|
        course.current_lesson_name
      end
    end
  end
end
