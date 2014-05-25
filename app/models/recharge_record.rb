class RechargeRecord < ActiveRecord::Base
  belongs_to :student
  belongs_to :recharge_code


  def sss(params=nil,student=nil)
    # 1. 标记充值码被使用
    # 2. 创建充值记录
    # 3. 把钱写入
    @recharge_record = RechargeRecord.new(params[:recharge_record].permit!)
    @recharge_code = RechargeCode.find_by(code: params[:recharge_record][:recharge_code],is_used: false)
  end
end
