class Student < User
  default_scope {where(role: 'student')}
  has_many :groups
  has_many :recharge_records
  has_many :courses,:through => :course_purchase_records
  has_many :course_purchase_records

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end

  def purchase_course(course_id)
    @course = Course.find(course_id)
    raise '课程不存在!' unless @course
    raise '课程不可购买!' unless @course.can_be_purchased

    begin
      raise '账户余额不够!' unless self.money > @course.price
      self.money -= @course.price
      self.courses << @course
      self.save
    rescue ActiveRecord::StaleObjectError
      self.reload
      retry
    rescue  ActiveRecord::RecordNotUnique
      raise '次课程已经购买'
    end

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