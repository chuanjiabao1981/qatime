module Recommend
  class LiveStudioCourseItem < Item
    self.recomend_for = LiveStudio::Course
    validates_presence_of :target

    def logo_url
      target.publicize_url(:list)
    end
  end
end
