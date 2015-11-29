module QaCommonState
  extend ActiveSupport::Concern
  class_methods do

    def __create_state_machine(completed_validation)
      include QaCustomizedCourseStateChangeRecord
      state_machine :state, initial: :new do
        transition :in_progress          => :completed,         :on => [:complete]
        transition :completed            => :in_progress,       :on => [:redo]
        transition :new                  => :completed,         :on => [:complete]

        before_transition :new => :in_progress, :do => :set_first_handled_at
        before_transition any => :completed,    :do => :set_completed_at

        event :handle do
          transition any - :completed => :in_progress
        end

        if not completed_validation.nil?
          state :completed do
            validates_with completed_validation
          end
        end

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

  def set_first_handled_at
    self.first_handled_at = DateTime.now
  end
  def set_completed_at
    self.completed_at     = DateTime.now
  end
end