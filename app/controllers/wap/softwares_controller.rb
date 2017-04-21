class Wap::SoftwaresController < Wap::ApplicationController
  skip_before_action :openid_required!
  def index
  end
end
