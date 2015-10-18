module AccountsHelper

  def consumption_type(fee)

    return unless fee and fee.feeable
    if fee.feeable_type == Reply.to_s
      fee.feeable.model_name.human
    elsif fee.feeable_type == Correction.to_s
      Correction.model_name.human
    elsif fee.feeable_type == CustomizedTutorial.to_s
      CustomizedTutorial.model_name.human
    end
  end

  def consumption_link(fee)
    return unless fee and fee.feeable
    if fee.feeable_type == CustomizedTutorial.to_s
      link_to "连接", customized_tutorial_path(fee.feeable) if fee.feeable
    elsif fee.feeable_type == Correction.to_s
      link_to "连接", solution_path(fee.feeable.solution) if fee.feeable and fee.feeable.solution
    elsif fee.feeable_type == Reply.to_s
      link_to "连接", send("#{fee.feeable.model_name.singular_route_key}_path",fee.feeable) if fee.feeable and fee.feeable.topic
    end
  end

  def videoable_object_stauts(o, dotter=false)
    if o.video
      if o.status == "closed"
        if dotter
          concat " • "
        end
        content_tag :span,style: 'color: darkgreen' do
          " 已结账"
        end
      else o.status == "open"
        if dotter
          concat " • "
        end
        content_tag :span,style: 'color: orange' do
          "未结账"
        end
      end
    end
  end
end
