module Entities
  module LiveStudio
    class Course < Grape::Entity
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
      expose :users_count, as: :buy_tickets_count
      expose :status
      expose :description, if: { type: :full }
      expose :tag_list, if: { type: :full }
      expose :lesson_count, if: { type: :full } do |course|
        course.lessons_count
      end
      expose :lessons_count, if: { type: :full }
      expose :preset_lesson_count do |course|
        course.lessons_count
      end
      expose :completed_lesson_count do |course|
        course.completed_lessons_count
      end
      expose :taste_count
      expose :completed_lessons_count
      expose :closed_lessons_count
      expose :started_lessons_count
      expose :live_start_time
      expose :live_end_time
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
      expose :lessons, using: Entities::LiveStudio::Lesson, if: { type: :full }
      expose :chat_team, using: Entities::Chat::Team, if: { type: :full } do |course|
        course.chat_team
      end
      expose :icons do
        expose :refund_any_time do |course|
          course.refund_any_time?
        end
        expose :coupon_free do |course|
          course.coupon_free?
        end
        expose :cheap_moment do |course|
          course.cheap_moment?
        end
        expose :join_cheap do |course|
          course.join_cheap?
        end
        expose :free_taste do |course|
          course.free_taste?
        end
      end
      expose :off_shelve do |course|
        course.off_shelve?
      end
      expose :taste_overflow do |course|
        course.taste_overflow?
      end
      expose :sell_type
    end
  end
end
