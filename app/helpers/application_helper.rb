module ApplicationHelper
  def user_home_path
    return signin_path unless signed_in?

    case current_user.role
      when "teacher"
        teachers_home_path
      when "admin"
        admins_home_path
      when "student"
        students_home_path
      when "manager"
        managers_home_path
      else
        root_path
    end
  end

  def get_edit_or_create_model_string(o)
    if o.new_record?
      "创建"+o.model_name.human
    else
      "编辑"+o.model_name.human
    end
  end

end