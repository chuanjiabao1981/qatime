module Entities
  module Common
    # 班级
    class Course < Grape::Entity
      expose :id
      expose :name
      expose :grade
      expose :subject
      expose :status
      expose :publicizes do |course|
        course.publicize.versions
      end
      expose :published_at
      expose :model_name
    end
  end
end
