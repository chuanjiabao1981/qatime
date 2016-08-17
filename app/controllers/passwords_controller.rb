class PasswordsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login_mobile!(password_params[:login_mobile])
    captcha_manager = UserService::CaptchaManager.new(password_params[:login_mobile])
    @user.captcha = captcha_manager.captcha_of(:get_password_back)
    if @user.update_with_captcha(password_params)
      captcha_manager.expire_captch(:get_password_back)
      redirect_to signin_path
    else
      @user.id = nil
      render :new
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
