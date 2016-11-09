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
        lesson.course.name.to_s
      end
      expose :course_publicize, if: {type: :schedule} do |lesson|
        lesson.course.publicize_url(:list).to_s
      end
      expose :subject, if: {type: :schedule} do |lesson|
        lesson.course.subject.to_s
      end
      expose :pull_address, if: {type: :schedule} do |lesson|
        ticket = ::LiveStudio::Ticket.where(student: options[:current_user],course: lesson.course).authorizable.last
        ticket.present? ? course.board_pull_stream : ''
      end

      expose :board_pull_stream
      expose :camera_pull_stream
      expose :chat_team_id, if: {type: :schedule} do |lesson|
        lesson.course.try(:chat_team).try(:team_id).to_s
      end
      expose :teacher_name, if: {type: :schedule} do |lesson|
        lesson.course.teacher.try(:name).to_s
      end
      expose :course_id, if: {type: :schedule} do |lesson|
        lesson.course.try(:id).to_s
      end
    end
  end
end
