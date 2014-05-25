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
      current_user.recharge(params)
    rescue => err
      @recharge_record = RechargeRecord.new
      flash[:warning] = err.to_s
      render 'new'
    end


  end
end
