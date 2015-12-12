class CustomizedCourseMessageBoard < ActiveRecord::Base

  include QaCustomizedCourseMessage

  belongs_to :customized_course
  has_many   :customized_course_messages ,lambda { order 'created_at desc' } , {dependent: :destroy}  do
    def build(attributes={})
      attributes[:customized_course_id]       = proxy_association.owner.customized_course_id
      super attributes
    end
  end

end