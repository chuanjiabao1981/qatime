class Wap::ApplicationController < ApplicationController
  layout 'wap'

  before_action :openid_required!

  def authorize
  end

  def openid_required!
    redirect_to oauth_url(request.original_url) if cookies[:openid].blank?
    @openid = cookies[:openid]
  end

  private
  helper_method :oauth_url
  def oauth_url(redirect_uri = nil)
    redirect_uri = redirect_uri.to_query('redirect_uri') if redirect_uri.present?
    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{WECHAT_CONFIG['appid']}&#{redirect_uri}&response_type=code&scope=snsapi_base&state=123#wechat_redirect"
  end
end
