module Entities
  class SearchTeacher < Entities::Teacher
    expose :province do |teacher|
      teacher.province.try(:name)
    end
    expose :city do |teacher|
      teacher.city.try(:name)
    end
    expose :school do |s|
      s.school.try(:name)
    end
  end
end