require_dependency "qawechat/application_controller"

module Qawechat
  class OmniauthCallbacksController < ApplicationController
    def wechat
      @user_info  = request.env["omniauth.auth"]
      cookies[:openid] = @user_info[:uid]
      cookies[:userinfo] = @user_info.to_json
      @wechat_user = WechatUser.find_by(openid: cookies[:openid])
      if @wechat_user.nil?
        redirect_to new_wechat_user_path
      else
        redirect_to wechat_user_path(@wechat_user)
      end
    end

    def login_callback
      code = params[:code]
      wechat_api = UserService::WechatApi.new(code)
      @wechat_user = wechat_api.web_access_token
      if @wechat_user.user.blank?
        redirect_to new_wechat_user_path
      else
        redirect_to user_path(@wechat_user.user)
      end
    end
  end
end
