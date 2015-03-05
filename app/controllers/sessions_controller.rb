class SessionsController < ApplicationController
  before_filter 'already_signin' ,only: [:new]
  def new
    @user = User.new
  end

  def create
    @user = User.where(email: params[:user][:email]).first
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      if @user.teacher?
        redirect_to teachers_home_path
      else
        redirect_to groups_path
      end
    else
      @user ||= User.new
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
