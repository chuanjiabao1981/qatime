module Entities
  module LiveStudio
    class VideoCourse < Grape::Entity
      format_with(:local_timestamp, &:to_i)
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :teacher_name
      expose :teacher, using: Entities::Teacher
      expose :price do |course|
        course.price.to_f.round(2)
      end
      expose :current_price do |course|
        course.current_price.to_f.round(2)
      end
      expose :chat_team_id do |course|
        nil
      end
      expose :chat_team_owner do |course|
        nil
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
      expose :objective
      expose :suit_crowd
      expose :teacher_percentage
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
      expose :chat_team do
        nil
      end
      expose :sell_type
      expose :total_duration
      expose :icons do
        expose :free_taste do |course|
          course.taste_count.to_i > 0
        end
        expose :coupon_free do |course|
          true
        end
        expose :cheap_moment do |course|
          false
        end
      end
      expose :off_shelve do |course|
        course.off_shelve?
      end
    end
  end
end
