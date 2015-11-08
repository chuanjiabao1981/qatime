class CustomizedCourseMessageBoard < MessageBoard
  include QaCustomizedCourseMessage
  has_many :customized_course_messages ,lambda { order 'created_at desc' } ,{foreign_key: :message_board_id} do
    def build(attributes={})
      attributes[:customized_course_id]       = proxy_association.owner.customized_course.id
      super attributes
    end
  end

  def customized_course
    self.messageboardable
  end
end