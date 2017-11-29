module Entities
  module LiveStudio
    class CourseMember < Grape::Entity
      expose :student_id
      expose :student_name
      expose :student_avatar
      expose :updated_at
      expose :created_at
    end
  end
end
