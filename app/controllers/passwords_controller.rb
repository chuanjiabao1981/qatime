class PasswordsController < ApplicationController
  layout 'application_login'

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login_account(password_params[:login_account]).try(:password_required!)
    if @user
      captcha_manager = UserService::CaptchaManager.new(password_params[:login_account])
      @user.captcha = captcha_manager.captcha_of(:get_password_back)
      if @user.update_with_captcha(password_params)
        captcha_manager.expire_captch(:get_password_back)
        if signed_in?
          redirect_to user_home_path, notice: t("flash.notice.update_success")
        else
          redirect_to new_session_path, notice: t("flash.notice.update_success")
        end
      else
        render :new
      end
    else
      @user = User.new(password_params)
      @user.add_error_for_login_account
      render :new
    end
  end

  def new_payment_password
    @user = User.new
  end

  def update_payment_password
    @user = User.find_by_login_account(payment_password_params[:login_account])
    if @user.blank?
      @user = User.new(payment_password_params)
      @user.add_error_for_login_account
      return render :new_payment_password
    end

    captcha_manager = UserService::CaptchaManager.new(payment_password_params[:login_account])
    @user.payment_captcha = captcha_manager.captcha_of(:payment_password)
    if @user.update_payment_pwd(payment_password_params)
      if signed_in?
        redirect_to user_home_path, notice: t("flash.notice.update_success")
      else
        redirect_to new_session_path, notice: t("flash.notice.update_success")
      end
    else
      render :new_payment_password
    end
  end

  private

  def password_params
    params.require(:user).permit(:login_account, :password, :password_confirmation, :captcha_confirmation)
  end

  def payment_password_params
    params.require(:user).permit(:login_account, :payment_password, :payment_password_confirmation, :payment_captcha_confirmation)
  end

  def current_resource
    @current_resource = User.find(params[:id]) if params[:id]
  end
end
