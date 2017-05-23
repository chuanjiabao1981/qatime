module Entities
  module LiveStudio
    class InteractiveCourseBase < Grape::Entity
      format_with(:local_timestamp, &:to_i)
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :price
      expose :status
      expose :description
      expose :lessons_count
      expose :completed_lessons_count
      expose :closed_lessons_count
      expose :started_lessons_count
      expose :live_start_time
      expose :live_end_time
      expose :objective
      expose :suit_crowd
      expose :teacher_percentage

      # 图片
      expose :publicize do
        expose :info_url do |c|
          c.url(:info)
        end
        expose :list_url do |c|
          c.url(:list)
        end
        expose :list_url do |c|
          c.url(:list)
        end
      end
      # 图片
      expose :icons do
        expose :refund_any_time do |_course|
          true
        end
        expose :coupon_free do |_course|
          true
        end
        expose :cheap_moment do |_course|
          false
        end
      end
      expose :off_shelve, &:off_shelve?
    end
  end
end
