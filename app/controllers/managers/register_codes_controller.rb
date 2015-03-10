class Managers::RegisterCodesController < ApplicationController
  def index
    @register_codes = RegisterCode.all.order(:created_at => "DESC").paginate(page: params[:page],:per_page => 10)
  end

  def create
    RegisterCode.create
    redirect_to managers_register_codes_path
  end
end
