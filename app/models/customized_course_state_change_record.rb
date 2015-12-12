class CustomizedCourseStateChangeRecord  < CustomizedCourseActionRecord


  def initialize(attributes = nil, options = {})
    super(attributes,options)
    self.send_sms_notification = false
  end
  def desc
    I18n.t("action.customized_course_state_change_record.state_change.desc",
           who:   self.operator.view_name,
           what:  self.actionable.model_name.human,
           from:  self.actionable.class.human_state_name(self.from),
           to:    self.actionable.class.human_state_name(self.to)
    )
  end
end