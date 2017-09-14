module Entities
  module LiveStudio
    class ScheduleLesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :class_date
      expose :replayable
      expose :left_replay_times
      expose :live_time
      expose :model_type do |lesson|
        lesson.model_name.to_s
      end
      expose :course_name do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.name.to_s
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.name.to_s
        else
          lesson.course.name.to_s
        end
      end
      expose :teacher_name do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.teacher.try(:name).to_s
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.teacher.try(:name).to_s
        else
          lesson.course.teacher.try(:name).to_s
        end
      end
      expose :course_publicize do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          ''
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.publicize_url(:list).to_s
        else
          lesson.course.publicize_url(:list).to_s
        end
      end
      expose :subject do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.subject.to_s
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.subject.to_s
        else
          lesson.course.subject.to_s
        end
      end
      expose :grade do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.grade.to_s
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.try(:grade).to_s
        else
          lesson.course.try(:grade).to_s
        end
      end
      expose :buy_tickets_count do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.buy_user_count
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.buy_user_count
        else
          lesson.course.buy_user_count
        end
      end
      expose :product_id do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course_id
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group_id
        else
          lesson.course_id
        end
      end
      expose :product_type do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.model_name
        elsif lesson.is_a?(::LiveStudio::Event)
          lesson.group.model_name
        else
          lesson.course.model_name
        end
      end
      expose :course_id
      expose :model_name
      # expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::Lesson) } do |instance, options|
      #   ::Entities::LiveStudio::Course.represent instance.course
      # end
      # expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::InteractiveLesson) } do |instance, options|
      #   ::Entities::LiveStudio::InteractiveCourse.represent instance.interactive_course
      # end
    end
  end
end
