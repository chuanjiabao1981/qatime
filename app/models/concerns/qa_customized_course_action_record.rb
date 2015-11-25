module QaCustomizedCourseActionRecord
  extend ActiveSupport::Concern
  included do

    has_many :customized_course_action_records,as: :actionable,dependent: :destroy do
      def build(attributes={})

        if defined? proxy_association.owner.customized_course_id  and proxy_association.owner.customized_course_id
          attributes[:customized_course_id]        = proxy_association.owner.customized_course_id
          attributes[:type]                        = CustomizedCourseActionRecord.to_s
        end
        super attributes
      end
    end

    after_create :__create_action_record
  end

  private
  def __create_action_record
    a = self.customized_course_action_records.build(name: :create,operator_id: self.last_operator.id)
    a.save
  end
end