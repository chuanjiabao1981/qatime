module Entities
  module LiveStudio
    class CourseDetail < CourseBase
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
      expose :users_count, as: :buy_tickets_count
      expose :status
      expose :description
      expose :tag_list
      expose :lessons_count
      expose :preset_lesson_count
      expose :taste_count
      expose :completed_lessons_count
      expose :closed_lessons_count
      expose :started_lessons_count
      expose :live_start_time
      expose :live_end_time
      expose :objective
      expose :suit_crowd
      expose :teacher_percentage
      expose :lessons, using: Entities::LiveStudio::CourseLesson
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
      expose :tastable?, as: :tastable
    end
  end
end
