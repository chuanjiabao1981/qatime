class Wap::WeixinController < Wap::ApplicationController

  def auth
    if cookies[:openid].blank?
      session[:return_to] = request.original_url
      redirect_to "#{WECHAT_CONFIG['host']}/auth/wechat?scope"
    end
    if cookies[:openid].blank?
      session[:return_to] = request.original_url
      redirect_to "#{WECHAT_CONFIG['host']}/auth/wechat"
      redirect_to weixin_auth_url
    end
  end

end
