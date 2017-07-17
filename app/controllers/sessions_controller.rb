class SessionsController < ApplicationController
  before_filter 'already_signin', only: [:new]
  layout 'application_login'

  def new
    @user = User.new
    @user.login_account = cookies[:remember_account].presence
  end

  def create
    @user = User.find_by_login_account(params[:user][:login_account])
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      if params[:remember_account] == '1'
        cookies.permanent[:remember_account] = params[:user][:login_account]
      end
      flash[:info] = "欢迎登录!"
      redirect_to params[:redirect_url].blank? ? after_sign_in_path : params[:redirect_url]
    else
      @user = User.new(login_mobile: @user.try(:login_account))
      flash.now[:warning] = "用户名或密码错误!"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to after_sign_out_path
  end

  private
    def already_signin
      if current_user
        flash[:warning] = "已登录！"
        redirect_to root_path
      end
    end
end
