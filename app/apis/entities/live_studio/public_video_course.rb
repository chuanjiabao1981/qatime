module Entities
  module LiveStudio
    # 公开信息
    class PublicVideoCourse < Grape::Entity
      expose :id
      expose :name
      expose :grade
      expose :price
      expose :current_price
      expose :subject
      expose :users_count, as: :buy_tickets_count
      expose :publicize do |course|
        course.publicize_url(:list)
      end
      expose :status
      expose :lessons_count
      expose :off_shelve do |course|
        course.off_shelve?
      end
      expose :sell_type
    end
  end
end
