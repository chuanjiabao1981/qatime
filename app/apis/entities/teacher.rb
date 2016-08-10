module Entities
  class Teacher < Entities::User
    expose :teaching_years
    expose :subject
    expose :grade_range
    expose :school do |teacher|
      teacher.school.name
    end
    expose :desc
  end
end
