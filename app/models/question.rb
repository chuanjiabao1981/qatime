class Question < ApplicationRecord
  include QaToken
  include ActiveModel::Dirty

  belongs_to :student
  belongs_to :learning_plan, counter_cache:true, inverse_of: :questions
  belongs_to :vip_class,counter_cache: true

  has_many :answers,dependent: :destroy

  has_many :comments,as: :commentable,dependent: :destroy

  has_many :teaching_videos #for test only
  has_many :question_assignments,:dependent => :destroy
  has_many :teachers,:through => :question_assignments

  validates :title, length:{minimum: 10,maximum: 200}
  validates :content, length: { minimum: 20 }
  validates_presence_of :student,:vip_class,:learning_plan,:teachers

  scope :by_learning_plan, lambda {|learning_plan_id| where('learning_plan_id = ?', learning_plan_id) if learning_plan_id}
  scope :by_vip_class,lambda {|v| where(vip_class_id: v) if v}
  scope :by_student, ->(student_id) { where(student_id: student_id) }

  before_validation :strip_whitespace

  after_destroy :decrement_count

  def initialize(atrributes={})
    super(atrributes)
    if self.learning_plan
      self.vip_class_id = self.learning_plan.vip_class_id
    end

  end


  def is_first_answered?
    # 如果以前从没被回答过
    return true if self.last_answer_info_was.empty? and not self.last_answer_info.empty?
  end

  def is_answered?
    return true if not self.last_answer_info.empty?
  end

  def is_first_answered_by_the_teacher?(teacher_id)
    # 最后一次回答此问题的teacher是否头一次回答此问题
    if self.last_answer_info["teacher_id"] == teacher_id and
        not self.answers_info_was[teacher_id.to_s] and
          self.answers_info[teacher_id.to_s] == true
        return true
    end
  end

  def is_responed_by_the_teacher?(teacher_id)
    # return true if self.answers_info and self.answers_info.include?(teacher_id.to_s)
    return true if self.teachers and self.teacher_ids.include?(teacher_id.to_i)

  end
  def is_answered_by_the_teacher?(teacher_id)
    # return true if  self.answers_info and self.answers_info[teacher_id.to_s]
    return true if self.answers and self.answers.find {|answer| answer.teacher.id == teacher_id.to_i}
  end


  def build_a_answer(teacher_id,attributes={})
    a                 = self.answers.build(attributes)
    a.teacher_id      = teacher_id
    a
  end

  def init_learning_plan(student)
    return if self.learning_plan
    # 如果没有设置learning_plan找一个teacher个数不为0
    if student.learning_plans.size > 0
      student.learning_plans.each do |learning_plan|
        if learning_plan.teachers.size > 0
          self.learning_plan = learning_plan
          break
        end
      end
    end
  end

private

  def decrement_count
    self.learning_plan.decrement_answered_questions_count(self) if self.learning_plan
  end



  def strip_whitespace
    self.title = self.title.strip
  end
end
