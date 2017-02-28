class Wap::ApplicationController < ApplicationController
  layout 'wap'

  before_action :openid_required!

  def authorize
  end

  def openid_required!
    if cookies[:openid].blank?
      session[:return_to] = request.original_url
      redirect_to "#{WECHAT_CONFIG['host']}/auth/wechat"
    end
    @openid = cookies[:openid]
  end
end
