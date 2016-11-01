module Entities
  module Recommend
    class TeacherItem < Item
      expose :target, as: :teacher, using: ::Entities::TeacherInfo
    end
  end
end
