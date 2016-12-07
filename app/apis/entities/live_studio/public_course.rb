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
      expose :buy_tickets_count
      expose :publicize do |course|
        course.publicize_url(:list)
      end
    end
  end
end
