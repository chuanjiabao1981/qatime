module LiveStudio
  class CourseActionRecord < ::ActionRecord
    belongs_to :live_studio_course, class_name: '::LiveStudio::Course'

    has_many :course_action_notifications, as: :notificationable,:dependent => :destroy do
      def build(attributes={})
        attributes[:operator_id]                   = proxy_association.owner.operator_id
        attributes[:customized_course_id]          = proxy_association.owner.live_studio_course_id
        super attributes
      end
    end

    def desc
      I18n.t "action.#{self.actionable.model_name.singular_route_key}.#{self.name}.desc",
                            user: self.operator.view_name
    end
  end
end
