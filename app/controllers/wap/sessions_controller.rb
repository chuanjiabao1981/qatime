class Wap::SessionsController < Wap::ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login_account(user_params[:login_account])
    if @user && @user.authenticate(user_params[:password])
      sign_in(@user)
      flash[:info] = I18n.t('wap.sessions.new.create_success')
      redirect_to params[:redirect_url].blank? ? user_home_path : params[:redirect_url]
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

end
