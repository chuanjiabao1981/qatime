class Admins::RechargeCodesController < ApplicationController
  layout "admin_home"
  def index
    @recharge_codes = RechargeCode.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
  end
  def new
    @recharge_code = RechargeCode.new
  end
  def create
    @recharge_code = RechargeCode.build_with_code(params[:recharge_code].permit!,current_user)
    if @recharge_code.save
      redirect_to admins_recharge_codes_path
    else
      render 'new'
    end
  end
  def show
    @recharge_code = RechargeCode.find(params[:id])
  end
end
