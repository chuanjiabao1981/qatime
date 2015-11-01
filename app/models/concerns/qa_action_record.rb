module QaActionRecord
  extend ActiveSupport::Concern
  included do

    has_many          :action_records,as: :actionable,dependent: :destroy do
      def build(attributes={})

        if defined? proxy_association.owner.customized_course_id  and proxy_association.owner.customized_course_id
          attributes[:customized_course_id]        = proxy_association.owner.customized_course_id
          attributes[:type]                        = CustomizedCourseActionRecord.to_s
        end
        attributes[:operator_id]                   = proxy_association.owner.operator_id
        super attributes
      end
    end

    after_create :__create_action_record
  end

  private
  def __create_action_record
    a = self.action_records.build(name: :create)
    a.save
  end
end