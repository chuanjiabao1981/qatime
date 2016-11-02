module Entities
  module Recommend
    class TeacherItem < Item
      expose :target, as: :teacher, using: ::Entities::TeacherInfo
      expose :logo_url do |item|
        item.target.avatar_url
      end
    end
  end
end
