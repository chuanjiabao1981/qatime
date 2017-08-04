class Wap::ApplicationController < ApplicationController
  layout 'wap'

  # before_action :openid_required!

  def authorize
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params
    else
      flash[:warning] = I18n.t("wap.authorize.warning")
      logger.info("====================")
      logger.info(request.referer)
      logger.info(current_user.try(:name))
      logger.info("====================")
      return wap_unauthorized
    end
  end

  def openid_required!
    # 用于自动化测试
    cookies[:openid] ||= "testopenid" if Rails.env.test?
    if cookies[:openid].blank?
      session[:return_to] = request.original_url
      redirect_to "#{WECHAT_CONFIG['host']}/auth/wechat2"
    end
    @openid = cookies[:openid]
  end
end
