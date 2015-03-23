class Student < User
  default_scope {where(role: 'student')}
  has_one  :account
  has_many :recharge_records
  has_many :groups,->{distinct},:through => :student_join_group_records
  has_many :student_join_group_records
  has_many :courses,:through => :course_purchase_records
  has_many :course_purchase_records


  has_many :questions

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end

  def purchase_course(course_id)
    @course = Course.find(course_id)
    raise '课程不存在!'   unless @course
    raise '课程不可购买!' unless @course.can_be_purchased
    begin
      raise '账户余额不够!' unless self.account.money > @course.price
      Student.transaction do
        self.courses << @course
        self.account.money -= @course.price
        self.account.save!
      end
    rescue ActiveRecord::RecordNotUnique
      raise '此课程已经购买!'
    rescue ActiveRecord::StaleObjectError
      self.reload
      retry
    end
    begin
      self.groups << @course.group
    rescue ActiveRecord::RecordNotUnique
      
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
    Account.update_counters self.account.id,:money => recharge_code.money

    recharge_code.money
  end
end