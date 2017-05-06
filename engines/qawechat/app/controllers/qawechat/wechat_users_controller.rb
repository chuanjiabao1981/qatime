require_dependency "qawechat/application_controller"

module Qawechat
  class WechatUsersController < ApplicationController
    def new
      if cookies[:openid].nil?
        flash.now[:warning] = "请关注微信公众号后绑定"
        render 'error'
      else
        @user = User.new
      end
    end

    def create
      @user = User.find_by_login_account(params[:user][:login_account])
      
      if @user && @user.authenticate(params[:user][:password])
        @wechat_user = WechatUser.find_by(openid: cookies[:openid])
        if @wechat_user.nil?
          @wechat_user = @user.wechat_users.create(openid: cookies[:openid], userinfo: cookies[:userinfo])
        else
          @wechat_user.update_attributes(userinfo: cookies[:userinfo], user_id: @user.id)
        end
        if @wechat_user.save
          groups = Wechat.api.groups
          group_id = 0
          groups["groups"].each do |g|
            if g["name"] == @user.role
              group_id = g["id"]
            end
          end
          if group_id == 0
            group_id = Wechat.api.group_create(@user.role)["group"]["id"]
          end
          Wechat.api.user_change_group(cookies[:openid],group_id)
          Wechat.api.custom_message_send Wechat::Message.to(cookies[:openid]).text("恭喜您，已经与#{@user.name}绑定成功，菜单会在5分钟后自动更新！")
          redirect_to wechat_user_path(@wechat_user)
        else
          render 'new'
        end
      else
        @user ||= User.new
        flash.now[:warning] = "用户名或密码错误!"
        render 'new'
      end
    end

    def show
      if cookies[:openid].nil?
        flash.now[:warning] = "请关注微信公众号后绑定"
        render 'error'
      else
        @wechat_user = WechatUser.where(id: params[:id]).first
        if @wechat_user.nil?
          render nothing: true
        end
      end
    end

    def destroy
      @wechat_user = WechatUser.find(params[:id])
      @wechat_user.destroy
      Wechat.api.user_change_group(cookies[:openid],'0')
      Wechat.api.custom_message_send Wechat::Message.to(cookies[:openid]).text("取消绑定成功，菜单会在5分钟后自动更新！")
      redirect_to new_wechat_user_path
    end
  end
end
