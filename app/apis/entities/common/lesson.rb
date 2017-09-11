module Entities
  module Common
    # 课
    class Lesson < Grape::Entity
      expose :id
      expose :name
      expose :grade
      expose :subject
      expose :status
      expose :publicizes do |lesson|
        lesson.publicize.versions
      end
      expose :course_id
      expose :course_name
      expose :model_name
      expose :teacher_id
      expose :teacher_name
    end
  end
end
