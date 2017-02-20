module Recommend
  class TeacherItem < Item
    self.recomend_for = Teacher
    validates_presence_of :target

    def logo_url
      target.avatar_url(:ex_big)
    end
  end
end
