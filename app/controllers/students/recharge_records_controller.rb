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
      current_user.recharge(10)
    rescue => err
      Rails.logger.info("==============|"+err+"-====================")
    end
    @recharge_record = RechargeRecord.new
    flash[:warning] = "ssss"

    render 'new'

  end
end
