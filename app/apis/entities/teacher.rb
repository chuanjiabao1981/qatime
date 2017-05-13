module Entities
  class Teacher < Entities::User
    expose :teaching_years
    expose :category
    expose :subject
    expose :grade_range
    expose :gender
    expose :birthday
    expose :province do |s|
      s.province_id
    end
    expose :city do |s|
      s.city_id
    end
    expose :school do |s|
      s.school_id
    end
    expose :school_id
    expose :desc
  end
end
