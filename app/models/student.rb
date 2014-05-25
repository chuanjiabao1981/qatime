class Student < User
  default_scope {where(role: 'student')}
  has_many :groups
  has_many :recharge_records

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end

  def recharge(code)
    code = code.strip
    recharge_code = RechargeCode.find_by(code: code,student_id: nil)
    raise '充值码错误' unless recharge_code

    # 1. 标记充值码被使用
    recharge_code.student   = self
    begin
      recharge_code.save
    rescue ActiveRecord::StaleObjectError
      raise '充值码状态错误，请重试!'
    end

    # 2. 创建充值记录
    recharge_record = RechargeRecord.new(code: code,student_id: self.id,recharge_code_id: recharge_code.id)
    recharge_record.save

    # 3. 把钱写入
    Student.update_counters self.id,:money => recharge_code.money

    recharge_code.money
  end
end