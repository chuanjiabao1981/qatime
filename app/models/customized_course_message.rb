class CustomizedCourseMessage < Message

  has_many :customized_course_message_replies,
           lambda { order 'created_at desc' } ,
           {foreign_key: :message_id, dependent: :destroy} do
    def build(attributes={})
      attributes[:customized_course_id]       = proxy_association.owner.customized_course.id
      attributes[:message_board_id]           = proxy_association.owner.message_board_id
      super attributes
    end
  end
  belongs_to :customized_course



end