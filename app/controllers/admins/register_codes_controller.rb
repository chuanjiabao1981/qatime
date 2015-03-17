class Admins::RegisterCodesController < ApplicationController
  layout "admin_home"
  respond_to :html

  def index
    @register_codes = RegisterCode.all.paginate(page: params[:page],:per_page => 10)
  end

end
