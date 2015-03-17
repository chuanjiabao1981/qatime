class Managers::RegisterCodesController < ApplicationController
  respond_to :html
  layout "manager_home"

  def index
    @register_codes = RegisterCode.all.order(:created_at => "DESC").paginate(page: params[:page],:per_page => 10)
  end
  def new
    @register_code = RegisterCode.new
  end

  def create
    @register_code = RegisterCode.new(params[:register_code].permit!)
    @register_code.make_value
    @register_code.save
    redirect_to managers_register_codes_path
  end
end
