module Recommend
  class LiveStudioCourseItem < Item
    self.recomend_for = LiveStudio::Course

    def logo_url
      target.publicize_url(:list)
    end
  end
end
