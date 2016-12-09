require_dependency "qawechat/application_controller"

module Qawechat
  class UsersController < ::ApplicationController
    layout 'application_login'
    skip_before_action :authorize
    before_action :set_wechat_user
    def new
      @user = User.new(type: params[:register_type])
    end

    def create
      @user = User.new(permit_params).register_columns_required!.captcha_required!.skip_accept_required!
      captcha_manager = UserService::CaptchaManager.new(permit_params[:login_mobile])
      @user.captcha = captcha_manager.captcha_of(:register_captcha)
      if @user.save
        sign_in(@user) unless signed_in?
        @wechat_user.update(user: @user)
        redirect_to user_home_path
      else
        render 'new'
      end
    end

    def remove_wechat
      @user = ::User.find(params[:id])
      @user.wechat_users.map(&:destroy!)
      redirect_to main_app.send("edit_#{@user.type.downcase}_path", @user, {cate: security_setting}), notice: '解除绑定成功'
    end

    private
    def set_wechat_user
      @wechat_user = WechatUser.find_by(openid: params[:openid])
    end

    def permit_params
      user_type = (params.keys & %w(teacher student user)).first
      params.require(user_type).permit(:login_mobile, :captcha_confirmation, :password, :type)
    end
  end
end
