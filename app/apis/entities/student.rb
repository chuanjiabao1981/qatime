module Entities
  class Student < Entities::User
    expose :email
    expose :mobile
    expose :parent_phone
    expose :grade
    expose :desc
    expose :address do |s|
      if s.province && s.city
        "%s %s"  [s.province.name, s.city.name]
      elsif s.city
        s.city.name
      end
    end
  end
end
