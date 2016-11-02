module Recommend
  class TeacherItem < Item
    self.recomend_for = Teacher

    def logo_url
      target.avatar_url
    end
  end
end
