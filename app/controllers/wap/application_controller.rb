class Wap::ApplicationController < ApplicationController
  layout 'wap'

  def authorize
    redirect_to '/auth/wechat' unless current_user.present?
    redirect_to '/auth/wechat' if current_user.wechat_users.blank?
  end
end
