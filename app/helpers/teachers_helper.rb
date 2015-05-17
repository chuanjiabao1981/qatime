module TeachersHelper

  def get_active_from_params(key,value)
    "active" if params[key] ==  value
  end
end
