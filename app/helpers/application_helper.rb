module ApplicationHelper
  def user_home_path
    return new_user_session_path unless user_signed_in?

    case current_user.role
      when "teacher"
        teachers_home_path
      when "admin"
        admins_home_path
      else
        root_path
    end
  end
end
