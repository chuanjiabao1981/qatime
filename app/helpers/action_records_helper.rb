module ActionRecordsHelper


  def render_action_record_name(action_record)
    render partial: "action_records/#{action_record.model_name.route_key}/name",
           locals:  {action_record: action_record}
  rescue
    I18n.t "action.#{action_record.actionable.model_name.singular_route_key}.#{action_record.name}.name"
  end

end
