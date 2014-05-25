class Students::RechargeRecordsController < ApplicationController
  layout 'student_home'

  def index
    @recharge_records = current_user.recharge_records
  end

  def new
    @recharge_record = RechargeRecord.new


  end
  def create
    begin
      val = current_user.recharge(params[:recharge_record][:code])
    rescue => err
      Rails.logger.info(err.to_s)
      @recharge_record = RechargeRecord.new
      flash.now[:warning] = err.to_s
      render 'new'
    else
      flash[:info] = "您成功充值#{val}元 !"
      redirect_to students_registration_path(current_user)
    end

  end
end
