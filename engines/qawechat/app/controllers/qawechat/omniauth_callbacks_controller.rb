require_dependency "qawechat/application_controller"

module Qawechat
  class OmniauthCallbacksController < ApplicationController
    include Qawechat::WechatHelper
    include ::SessionsHelper

    def wechat
      @user_info = request.env["omniauth.auth"]
      cookies[:openid] = @user_info[:uid]
      cookies[:userinfo] = @user_info.to_json
      @wechat_user = WechatUser.find_by(openid: cookies[:openid])
      if session[:return_to]
        return_to = session.delete(:return_to)
        redirect_to return_to
      elsif @wechat_user.nil?
        redirect_to new_wechat_user_path
      else
        redirect_to wechat_user_path(@wechat_user)
      end
    end

    def login_callback
      code = params[:code]
      wechat_api = UserService::WechatApi.new(code, 'web')
      @wechat_user = wechat_api.web_access_token
      if @wechat_user.blank?
        redirect_to '/sessions/new'
      else
        if @wechat_user.user.blank?
          if current_user.present?
            UserService::WechatApi.binding_user(@wechat_user.openid, current_user)
            redirect_to main_app.send("edit_#{current_user.type.downcase}_path",current_user, {cate: 'security_setting'}), notice: '绑定微信成功'
          else
            redirect_to qawechat.new_user_path(openid: @wechat_user.openid, register_type: params[:register_type])
          end
        else
          sign_in(@wechat_user.user)
          redirect_to main_app.root_path
        end
      end
    end
  end
end
