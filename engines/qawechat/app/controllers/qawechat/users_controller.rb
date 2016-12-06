require_dependency "qawechat/application_controller"

module Qawechat
  class WechatUsersController < ApplicationController
    def new
      @wechat_user = WechatUser.find_by(openid: params[:openid])
      @user = User.new
    end
  end
end
