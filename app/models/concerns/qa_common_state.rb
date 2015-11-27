module QaCommonState
  extend ActiveSupport::Concern
  included do

    include QaCustomizedCourseStateChangeRecord

    state_machine :state, initial: :new do
      transition :new                  => :in_progress,       :on => [:handled]
      transition :in_progress          => :completed,         :on => [:complete]
      transition :completed            => :in_progress,       :on => [:redo]
      transition :new                  => :completed,         :on => [:complete]

      after_transition do |state_object,transition|

        a = state_object.customized_course_state_change_records.build(
            name: :state_change,
            from: transition.from,
            to: transition.to,
            event: transition.event,
            operator_id: state_object.last_operator.id
        )
        a.save
      end
    end
  end
end