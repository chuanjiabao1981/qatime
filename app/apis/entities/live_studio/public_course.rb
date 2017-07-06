module Entities
  module LiveStudio
    # 辅导班公开信息
    class PublicCourse < Grape::Entity
      expose :id
      expose :name
      expose :grade
      expose :price
      expose :current_price
      expose :subject do |course|
        course.subject.to_s
      end
      expose :buy_tickets_count do |course|
        course.buy_user_count
      end
      expose :publicize do |course|
        course.publicize_url(:list)
      end
      expose :status
      expose :lessons_count
      expose :is_finished do |course|
        course.completed?
      end
      expose :off_shelve do |course|
        course.off_shelve?
      end
      expose :sell_type
    end
  end
end
