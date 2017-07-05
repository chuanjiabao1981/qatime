module Entities
  module LiveStudio
    class CourseDetail < CourseBase
      expose :teacher, using: Entities::Teacher
      expose :price do |course|
        course.price.to_f.round(2)
      end
      expose :current_price
      expose :buy_tickets_count do |course|
        course.buy_user_count
      end
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
          true
        end
        expose :coupon_free do |course|
          true
        end
        expose :cheap_moment do |course|
          false
        end
        expose :join_cheap do |course|
          course.join_cheap?
        end
        expose :free_taste do |course|
          course.taste_count.to_i > 0
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
