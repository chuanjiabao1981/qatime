module Entities
  class Student < Entities::User
    expose :gender
    expose :birthday
    expose :grade
    expose :province do |s|
      s.province_id
    end
    expose :city do |s|
      s.city_id
    end
    expose :school do |s|
      s.school_id
    end
    expose :desc
  end
end
