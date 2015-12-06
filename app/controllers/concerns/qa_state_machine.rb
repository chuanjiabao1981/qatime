module QaStateMachine
  extend ActiveSupport::Concern
  class_methods do
    def __event_actions(state_machine_class,state_variable_name)
      state_machine_class.state_machines[:state].events.map(&:name).each do |event|
        define_method(event) do
          _state_object               = instance_variable_get("@#{state_variable_name}")
          _state_object.last_operator = current_user
          _state_object.state_event   = event
          _state_object.save
          @object_state               = _state_object
          @use_super_controller       = params[:use_super_controller].nil? ? false : params[:use_super_controller] == 'true'

          error_message               = nil
          if not _state_object.valid?
            _state_object.errors.each do |k,v|
              error_message = v.to_s
            end
          end
          respond_to do |format|
            format.html do
              if error_message
                flash[:danger] = error_message
              end
              redirect_to send("#{_state_object.model_name.singular_route_key}_path",_state_object)
            end
            ##暂时没有用，先保留js返回
            format.js   {render 'shared/events/event'}
          end
        end
      end
    end
  end
end