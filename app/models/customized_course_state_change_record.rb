class CustomizedCourseStateChangeRecord  < CustomizedCourseActionRecord
  belongs_to :stateactionable,polymorphic: true,foreign_key: :actionable_id,foreign_type: :actionable_type


  def initialize(attributes = nil, options = {})
    super(attributes,options)
    self.send_sms_notification = false
  end
  def desc
    I18n.t("action.customized_course_state_change_record.state_change.desc",
           who:   self.operator.view_name,
           what:  self.stateactionable.model_name.human,
           from:  self.stateactionable.human_state_name(self.from),
           to:    self.stateactionable.human_state_name(self.to)
    )
  end
end