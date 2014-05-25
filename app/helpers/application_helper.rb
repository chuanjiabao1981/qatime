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
      else
        root_path
    end
  end

  def generate_video_download_token
    @download_token = Qiniu::RS.generate_download_token :expires_in => 300,
                                                        :pattern => "qatime.qiniudn.com/uploads/*"
    @download_token
  end

end