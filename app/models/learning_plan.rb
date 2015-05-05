class LearningPlan < ActiveRecord::Base
  belongs_to :student
  belongs_to :vip_class

  validates :duration_type, inclusion: { in: APP_CONSTANT["learning_plan"]["duration_types"].keys,
                                message: "%{value} is not a valid type" }

  validates_presence_of :student,:vip_class,:price,:begin_at,:end_at,:teachers,:duration_type

  has_many :teachers ,through: :learning_plan_assignments
  has_many :learning_plan_assignments,dependent: :destroy
  has_many :questions,inverse_of: :learning_plan



  def get_the_teacher_assignment(teacher_id)
    self.learning_plan_assignments.find{|a| a.teacher_id == teacher_id}
  end

  def get_the_teacher(teacher_id)
    self.teachers.find{|t| t.id == teacher_id}
  end
  def expired?
    return false if self.begin_at <= Time.zone.now and Time.zone.now <= self.end_at
    true
  end
  def not_started?
    return true if Time.zone.now < self.begin_at
  end
  def initialize(attributes = {})
    super(attributes)
    self.vip_class_id = 1 if not self.vip_class_id
    #选择一个最晚结束的plan
    a                 = self.student.select_last_valid_learning_plan(self.vip_class_id) if self.student
    if a
      #如果选取到了那么就从这个结束开始继续
      self.begin_at   = (a.end_at + 1.day).beginning_of_day
    else
      #如果没有就从当前开始
      self.begin_at   = Time.zone.now.to_date
    end
    if self.duration_type
      self.end_at     = (self.begin_at + eval(APP_CONSTANT["learning_plan"]["duration_types"][self.duration_type]["time"])).end_of_day
      self.price      = APP_CONSTANT["learning_plan"]["duration_types"][self.duration_type]["price"]
    end
  end

  def update_answered_questions_count(question)
    # 如果question是第一次被解决，那么增加answered_questions_count
    if question.is_first_answered?
      self.class.where("id=#{self.id}").update_all("answered_questions_count = answered_questions_count + 1")
    end
    self.learning_plan_assignments.each do |assignment|
      assignment.update_answered_questions_count(question)
    end
  end

  def decrement_answered_questions_count(question)
    if question.is_answered?
      self.class.where("id=#{self.id}").update_all("answered_questions_count = answered_questions_count - 1")
    end
    self.learning_plan_assignments.each do |assignment|
      assignment.decrement_answered_questions_count(question)
    end
  end

end


