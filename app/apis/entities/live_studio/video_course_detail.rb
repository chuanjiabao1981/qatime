module Entities
  module LiveStudio
    class VideoCourseDetail < VideoCourseBase
      expose :teacher, using: Entities::Teacher
      expose :price do |course|
        course.price.to_f.round(2)
      end
      expose :buy_tickets_count do |course|
        course.buy_user_count
      end
      expose :status
      expose :description
      expose :tag_list
      expose :video_lessons_count
      expose :taste_count
      expose :objective
      expose :suit_crowd
      expose :video_lessons, using: Entities::LiveStudio::VideoCourseLesson
      expose :sell_type
      expose :total_duration
      expose :icons do
        expose :free_taste do |course|
          course.taste_count.to_i > 0
        end
        expose :coupon_free do |_course|
          true
        end
        expose :cheap_moment do |_course|
          false
        end
      end
    end
  end
end
