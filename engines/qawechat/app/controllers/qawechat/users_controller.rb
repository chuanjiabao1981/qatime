require_dependency "qawechat/application_controller"

module Qawechat
  class WechatUsersController < ApplicationController
    def new
      @user = User.new
    end
  end
end
