module Entities
  module LiveStudio
    # 公开信息
    class PublicInteractiveCourse < Grape::Entity
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :price
      expose :current_price
      expose :publicize do |course|
        course.publicize_url(:list)
      end
      expose :publicize_info_url do |course|
        course.publicize_url(:info)
      end
      expose :status
      expose :lessons_count
      expose :is_finished do |course|
        course.is_finished?
      end
      expose :off_shelve do |course|
        course.off_shelve?
      end
    end
  end
end
