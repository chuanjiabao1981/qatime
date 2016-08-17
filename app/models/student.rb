class Student < User
  default_scope {where(role: 'student')}

  has_many :deposits
  has_many :recharge_records

  has_many :courses,:through => :course_purchase_records
  has_many :course_purchase_records ,:dependent => :destroy
  has_many :questions,:dependent => :destroy
  has_many :learning_plans ,-> { order 'created_at desc' } ,:dependent => :destroy
  has_many :not_finished_learning_plans, -> {where("? <= end_at",Time.zone.now.to_date)},class_name:'LearningPlan'
  has_many :customized_courses,->{order(created_at: :desc)},:dependent => :destroy
  has_many :solutions,:dependent => :destroy

  # 直播
  has_many :live_studio_tickets, class_name: LiveStudio::Ticket
  has_many :live_studio_courses, class_name: LiveStudio::Course, through: :live_studio_tickets, source: :course
  has_many :live_studio_taste_tickets, class_name: LiveStudio::TasteTicket

  # validates_presence_of :parent_phone, :on => :create
  # validates :parent_phone, length:{is: 11}, :on => :create
  # validates :parent_phone,numericality: { only_integer: true },:on => :create

  attr_accessor :accept
  validates :accept, acceptance: true

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
      #self.groups << @course.group
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
