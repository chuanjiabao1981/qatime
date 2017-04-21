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
      expose :buy_tickets_count do |course|
        course.buy_user_count
      end
      expose :publicize do |course|
        course.publicize_url(:list)
      end
      expose :status
      expose :lessons_count
    end
  end
end
