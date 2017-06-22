class SessionsController < ApplicationController
  before_filter 'already_signin' ,only: [:new]
  layout 'application_login'
  def new
    @user = User.new
  end

  def create
    # @user = User.find_by(email: params[:user][:email])
    @user = User.find_by_login_account(params[:user][:login_account])
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      flash[:info] = "欢迎登录!"
      redirect_to params[:redirect_url].blank? ? root_path : params[:redirect_url]
    else
      # @user = User.new(email: @user.try(:email))
       @user = User.new(login_mobile: @user.try(:login_account))
      flash.now[:warning] = "用户名或密码错误!"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
    def already_signin
      if current_user
        flash[:warning] = "已登录！"
        redirect_to root_path
      end
    end
end
