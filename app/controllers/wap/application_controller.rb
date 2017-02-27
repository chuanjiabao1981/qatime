class Wap::ApplicationController < ApplicationController
  layout 'wap'

  before_action :openid_required!

  def authorize
  end

  def openid_required!
    redirect_to oauth_url(request.original_url) if cookies[:openid].blank?
    @openid = cookies[:openid]
  end
end
