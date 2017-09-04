module Entities
  module LiveStudio
    # 个人主页专属课
    class PublicCustomizedGroup < Grape::Entity
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
      expose :events_count
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
