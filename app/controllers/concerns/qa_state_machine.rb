module QaStateMachine
  extend ActiveSupport::Concern
  class_methods do
    def __event_actions(state_machine_class,state_variable_name)
      state_machine_class.state_machines[:state].events.map(&:name).each do |event|
        define_method(event) do
          _state_object              = instance_variable_get("@#{state_variable_name}")
          _state_object.state_event  = event
          _state_object.save
          @object_state              = _state_object
          @use_super_controller      = params[:use_super_controller].nil? ? false : params[:use_super_controller] == 'true'
          if not _state_object.valid?
            puts _state_object.errors.full_messages
            puts _state_object.to_json
          end
          render 'shared/events/event'
        end
      end
    end
  end
end