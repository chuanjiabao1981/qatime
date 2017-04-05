module Entities
  module LiveStudio
    class Lesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :class_date
      expose :live_time
      expose :live_token, if: { type: :live_start } do |lesson|
        lesson.current_live_session.token
      end
      expose :course_name, if: {type: :schedule} do |lesson|
        lesson.try(:course).try(:name).to_s.presence || lesson.try(:interactive_course).try(:name).to_s
      end
      expose :course_publicize, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          ''
        else
          lesson.course.publicize_url(:list).to_s
        end
      end
      expose :subject, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.subject.to_s
        else
          lesson.course.subject.to_s
        end
      end
      expose :grade, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.interactive_course.grade.to_s
        else
          lesson.course.try(:grade).to_s
        end
      end
      expose :pull_address, if: {type: :schedule} do |lesson|
        product = lesson.try(:course) || lesson.try(:interactive_course)
        ticket = ::LiveStudio::Ticket.where(student: options[:current_user], product: product).authorizable.last
        ticket.present? ? lesson.try(:course).try(:board_pull_stream) : ''
      end

      expose :board_pull_stream do |lesson|
        lesson.try(:course).try(:board_pull_stream)
      end
      expose :camera_pull_stream do |lesson|
        lesson.try(:course).try(:camera_pull_stream)
      end
      expose :chat_team_id, if: {type: :schedule} do |lesson|
        lesson.try(:course).try(:chat_team).try(:team_id).to_s
      end
      expose :board, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          ''
        else
          lesson.course.pull_streams.find {|stream| stream.use_for == 'board' }.try(:address)
        end
      end
      expose :camera, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          ''
        else
          lesson.course.pull_streams.find {|stream| stream.use_for == 'camera' }.try(:address)
        end
      end
      expose :chat_team_id, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          ''
        else
          lesson.course.try(:chat_team).try(:team_id).to_s
        end
      end
      expose :teacher_name, if: {type: :schedule} do |lesson|
        if lesson.is_a? ::LiveStudio::InteractiveLesson
          lesson.teacher.try(:name).to_s
        else
          lesson.course.teacher.try(:name).to_s
        end
      end
      expose :product_id, if: { type: :schedule } do |lesson|
        lesson.try(:course_id) || lesson.try(:interactive_course_id)
      end
      expose :product_interactive_course, using: Entities::LiveStudio::InteractiveCourse, if: { type: :schedule } do |lesson|
        lesson.try(:interactive_course)
      end
      expose :product_course, using: Entities::LiveStudio::Course, if: { type: :schedule } do |lesson|
        lesson.try(:course)
      end
      expose :course_id, if: {type: :schedule} do |lesson|
        lesson.course.try(:id).to_s
      end
      expose :replayable
      expose :left_replay_times

      expose :modal_type do |lesson|
        lesson.model_name.to_s
      end
      expose :lesson_name, if: {type: :schedule} do |lesson|
        lesson.name.to_s
      end
    end
  end
end
