class SessionsController < ApplicationController
  before_filter 'already_signin' ,only: [:new]
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      flash[:info] = "欢迎登录!"
      redirect_to user_home_path
    else
      @user = User.new(email: @user.try(:email))
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
