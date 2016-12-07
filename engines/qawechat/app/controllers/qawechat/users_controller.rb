require_dependency "qawechat/application_controller"

module Qawechat
  class UsersController < ::ApplicationController
    layout 'application_login'
    skip_before_action :authorize
    def new
      @wechat_user = WechatUser.find_by(openid: params[:openid])
      @user = User.new
    end
  end
end
