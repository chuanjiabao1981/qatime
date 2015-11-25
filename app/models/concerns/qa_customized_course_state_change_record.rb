module QaCustomizedCourseStateChangeRecord
  extend ActiveSupport::Concern
  included do

    has_many  :customized_course_state_change_records, as: :stateactionable,foreign_key: :actionable_id,foreign_type: :actionable_type do
      def build(attributes={})
        if defined? proxy_association.owner.customized_course_id  and proxy_association.owner.customized_course_id
          attributes[:customized_course_id]        = proxy_association.owner.customized_course_id
        end
        attributes[:actionable_type]               = Solution.to_s
        super attributes
      end
    end
  end
end