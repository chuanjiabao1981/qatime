module QaCustomizedCourseMessage
  extend ActiveSupport::Concern
  included do
    def all_participants
      self.customized_course.all_participants
    end
  end
end