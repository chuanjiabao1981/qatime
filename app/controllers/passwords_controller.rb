class PasswordsController < ApplicationController
  def edit
  end

  def update
    if params[:teacher]
      model_name = :teacher
    elsif params[:student]
      model_name = :student
    else
      model_name = :user
    end

    password_params = params.require(model_name).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation)
    captcha_key = "captcha-#{password_params[:login_mobile]}"

    session[captcha_key]
    @user = User.find_by(login_mobile: password_params[:login_mobile])

    if @user
      @user.captcha = UserService::CaptchaManager.captcha_of(session[captcha_key])
      @user.if_update_password = 1
      if @user.update(password_params)
        if @current_resource
          redirect_to new_session_path, notice: t("flash.notice.update_success")
        else
          redirect_to user_home_path, notice: t("flash.notice.update_success")
        end
      else
        render :edit
      end
    else
      redirect_to root_path, alert: t("flash.alert.no_user")
    end
  end
end
