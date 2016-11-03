module Recommend
  class TeacherItem < Item
    self.recomend_for = Teacher

    def logo_url
      target.avatar_url(:ex_big)
    end
  end
end
