module AccountsHelper

  def consumption_type(fee)
    return unless fee and fee.feeable
    fee.feeable.model_name.human
  end

  def consumption_link(fee)
    return unless fee and fee.feeable
    link_to "连接", send("#{fee.feeable.model_name.singular_route_key}_path",fee.feeable) if fee.feeable
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
