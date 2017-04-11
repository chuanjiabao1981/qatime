module Entities
  module LiveStudio
    class VideoCourse < Grape::Entity
      expose :id
      expose :name
      expose :subject do |course|
        course.subject.to_s
      end
      expose :grade do |course|
        course.grade.to_s
      end
      expose :teacher_name do |course|
        course.teacher.try(:name).to_s
      end
      expose :teacher, using: Entities::Teacher
      expose :price do |course|
        course.price.to_f.round(2)
      end
      expose :current_price
      expose :chat_team_id do |course|
        course.try(:chat_team).try(:team_id).to_s
      end
      expose :chat_team_owner do |course|
        course.try(:chat_team).try(:owner).to_s
      end
      expose :buy_tickets_count do |course|
        course.buy_user_count
      end
      expose :status
      expose :description, if: { type: :full }
      expose :tag_list, if: { type: :full }
      expose :lesson_count do |course|
        course.video_lessons_count
      end
      expose :video_lessons_count
      expose :preset_lesson_count do |course|
        course.video_lessons_count
      end
      expose :completed_lesson_count do |course|
        course.completed_lessons_count
      end
      expose :taste_count
      expose :completed_lessons_count
      expose :closed_lessons_count
      expose :live_start_time
      expose :live_end_time
      expose :objective
      expose :suit_crowd
      expose :publicize do |course|
        case options[:size]
          when :search
            course.publicize_url(:info)
          when :info
            course.publicize_url(:app_info)
          else
            course.publicize_url(:list)
        end
      end
      expose :video_lessons, using: Entities::LiveStudio::VideoCourseLesson, if: { type: :full }
      expose :chat_team, using: Entities::Chat::Team, if: { type: :full } do |course|
        course.chat_team
      end
      expose :sell_type
    end
  end
end