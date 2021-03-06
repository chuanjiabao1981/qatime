class Wap::SessionsController < Wap::ApplicationController
  before_filter 'already_signin', only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login_account(user_params[:login_account])
    if @user && @user.authenticate(user_params[:password])
      sign_in(@user)
      flash[:info] = I18n.t('wap.sessions.new.create_success')
      redirect_to wap_after_sign_in_path
    else
      @user = User.new(login_mobile: @user.try(:login_account))
      flash[:warning] = I18n.t('wap.sessions.new.create_error')
      redirect_to :back
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:login_account, :password)
  end

  def already_signin
    redirect_to wap_after_sign_in_path if signed_in?
  end

end
