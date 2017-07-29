class Student < User
  include Registable

  default_scope {where(role: 'student')}

  has_many :deposits
  has_many :recharge_records

  has_many :courses, :through => :course_purchase_records
  has_many :course_purchase_records, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :learning_plans, -> { order 'created_at desc' }, :dependent => :destroy
  has_many :not_finished_learning_plans, -> {where("? <= end_at",Time.zone.now.to_date)}, class_name: 'LearningPlan'
  has_many :customized_courses,->{order(created_at: :desc)},:dependent => :destroy
  has_many :solutions,:dependent => :destroy

  # 直播
  has_many :live_studio_tickets, class_name: LiveStudio::Ticket
  has_many :live_studio_buy_tickets, class_name: LiveStudio::BuyTicket
  has_many :live_studio_taste_tickets, class_name: LiveStudio::TasteTicket

  has_many :live_studio_ticket_items, class_name: 'LiveStudio::TicketItem', foreign_key: :user_id

  ## 直播课
  has_many :live_studio_courses, class_name: LiveStudio::Course, through: :live_studio_tickets, source: :product, source_type: LiveStudio::Course
  has_many :live_studio_lessons, class_name: LiveStudio::Lesson, through: :live_studio_ticket_items, source: :target, source_type: 'LiveStudio::Lesson'
  has_many :live_studio_bought_courses, class_name: LiveStudio::Course, through: :live_studio_buy_tickets, source: :product, source_type: LiveStudio::Course
  has_many :live_studio_taste_courses, class_name: LiveStudio::Course, through: :live_studio_taste_tickets, source: :product, source_type: LiveStudio::Course

  # 一对一
  has_many :live_studio_interactive_courses, class_name: LiveStudio::InteractiveCourse, through: :live_studio_tickets, source: :product, source_type: LiveStudio::InteractiveCourse
  has_many :live_studio_interactive_lessons, class_name: LiveStudio::InteractiveLesson, through: :live_studio_ticket_items, source: :target, source_type: 'LiveStudio::InteractiveLesson'
  has_many :live_studio_bought_interactive_courses, class_name: LiveStudio::InteractiveCourse, through: :live_studio_buy_tickets, source: :product, source_type: LiveStudio::InteractiveCourse
  has_many :live_studio_taste_interactive_courses, class_name: LiveStudio::InteractiveCourse, through: :live_studio_taste_tickets, source: :product, source_type: LiveStudio::InteractiveCourse

  # 视频课
  has_many :live_studio_video_courses, class_name: LiveStudio::VideoCourse, through: :live_studio_tickets, source: :product, source_type: LiveStudio::VideoCourse
  has_many :live_studio_video_lessons, class_name: LiveStudio::VideoLesson, through: :live_studio_video_courses, source: :video_lessons
  has_many :live_studio_bought_video_courses, class_name: LiveStudio::VideoCourse, through: :live_studio_buy_tickets, source: :product, source_type: LiveStudio::VideoCourse
  has_many :live_studio_taste_video_courses, class_name: LiveStudio::VideoCourse, through: :live_studio_taste_tickets, source: :product, source_type: LiveStudio::VideoCourse

  # 专属课
  has_many :live_studio_customized_groups, class_name: LiveStudio::CustomizedGroup, through: :live_studio_tickets, source: :product, source_type: LiveStudio::Group
  has_many :live_studio_bought_customized_groups, class_name: LiveStudio::CustomizedGroup, through: :live_studio_buy_tickets, source: :product, source_type: LiveStudio::Group

  attr_reader :student_columns_required

  validates_confirmation_of :parent_phone

  validates :name, length: { in: 1..30 }, on: :update

  # 第二步注册，学生更新验证
  validates_presence_of :grade, :city_id, if: :student_columns_required?, on: :update
  validates :city, presence: true, if: :city_id_changed?, on: :update

  validates :parent_phone, allow_blank: true, length: { is: 11 }, numericality: { only_integer: true }, on: :update

  # 修改个人安全信息验证
  validates :parent_phone, length: { is: 11 }, numericality: { only_integer: true }, if: :parent_phone_changed?, on: :update

  # 修改个人信息（非找回密码，非admin修改个人信息）
  # TO DO
  # validates_presence_of :avatar, :name, on: :update

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

  # 学生必填的字段
  def student_columns_required?
    @student_columns_required == true || teacher_or_student_columns_required?
  end

  # 强制设置学生必填字段
  def student_columns_required!
    teacher_or_student_columns_required!
    @student_columns_required = true
    self
  end
end
