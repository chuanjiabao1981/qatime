module AccountsHelper

  def consumption_type(fee)
    if fee.feeable_type == Reply.to_s
      Homework.human_attribute_name(:topics)
    elsif fee.feeable_type == Correction.to_s
      Correction.model_name.human
    elsif fee.feeable_type == CustomizedTutorial.to_s
      CustomizedTutorial.model_name.human
    end
  end

  def consumption_link(fee)
    return unless fee
    if fee.feeable_type == CustomizedTutorial.to_s
      link_to "连接", customized_tutorial_path(fee.feeable) if fee.feeable
    elsif fee.feeable_type == Correction.to_s
      link_to "连接", solution_path(fee.feeable.solution) if fee.feeable and fee.feeable.solution
    elsif fee.feeable_type == Reply.to_s
      link_to "连接", topic_path(fee.feeable.topic) if fee.feeable and fee.feeable.topic
    end
  end

  # def object_is_closed(o)
  #   content_tag :span,style: 'color: '
  # end
end
