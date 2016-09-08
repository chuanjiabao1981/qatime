module LiveStudio::QaCourseActionRecord
  extend ActiveSupport::Concern
  included do
    has_many :course_action_records,as: :actionable,dependent: :destroy do
      def build(attributes={})
        if defined? proxy_association.owner.live_studio_course_id  and proxy_association.owner.live_studio_course_id
          attributes[:live_studio_course_id]        = proxy_association.owner.live_studio_course_id
          attributes[:type]                        = ::LiveStudio::CourseActionRecord.to_s
        end
        super attributes
      end
    end
  end
end
