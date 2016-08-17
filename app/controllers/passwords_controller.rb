class PasswordsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login_mobile!(password_params[:login_mobile])
    captcha_manager = UserService::CaptchaManager.new(password_params[:login_mobile])
    @user.captcha = captcha_manager.captcha_of(:get_password_back)
    if @user.update_with_captha(password_params)
      captcha_manager.expire_captch(:get_password_back)
      redirect_to signin_path
    else
      @user.id = nil
      render :new
    end
  end

  def edit
    @current_resource ||= User.new
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
    @current_resource = @current_resource || User.find_by_mobile_or_login_mobile(password_params[:login_mobile])
    if @current_resource
      @current_resource.captcha = UserService::CaptchaManager.captcha_of(session[captcha_key])
      @current_resource.if_update_password = 1
      if @current_resource.update(password_params)
        session.delete(captcha_key)
        @current_resource.if_update_password = nil
        if signed_in?
          redirect_to user_home_path, notice: t("flash.notice.update_success")
        else
          redirect_to new_session_path, notice: t("flash.notice.update_success")
        end
      else
        render :edit
      end
    else
      redirect_to root_path, alert: t("flash.alert.no_user")
    end
  end

  private

  def password_params
    params.require(:user).permit(:login_mobile, :password, :password_confirmation, :captcha_confirmation)
  end

  def current_resource
    @current_resource = User.find(params[:id]) if params[:id]
  end
end
