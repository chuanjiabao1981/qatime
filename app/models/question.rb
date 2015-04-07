class Question < ActiveRecord::Base
  include ActiveModel::Dirty

  belongs_to :student
  belongs_to :learning_plan, counter_cache:true
  belongs_to :vip_class,counter_cache: true
  has_many :answers
  has_many :pictures,as: :imageable

  validates :title, length:{minimum: 10,maximum: 200}
  validates :content, length: { minimum: 20 }
  validates_presence_of :student,:vip_class,:learning_plan

  scope :by_learning_plan, lambda {|learning_plan_id| where('learning_plan_id = ?', learning_plan_id) if learning_plan_id}
  scope :by_teacher,lambda{|teacher_id| where("answers_info ? :teacher_id",{teacher_id: teacher_id}) if teacher_id}
  scope :by_vip_class,lambda {|v| where(vip_class_id: v) if v}


  after_save :update_picture_info

  def initialize(atrributes={})
    super(atrributes)
    if self.vip_class and self.student
      self.learning_plan = self.student.select_a_valid_learning_plan(self.vip_class)
      if self.learning_plan
        self.answers_info         = self.learning_plan.teacher_ids.inject({}){|h,o| h[o.to_s]=false;h}
      end
    end
  end

  def update_answers_info(answer)
    return if answer == nil
    self.answers_info[answer.teacher.id.to_s]   = true
    self.last_answer_info["teacher_name"]  = answer.teacher.name
    self.last_answer_info["answered_at"]   = answer.created_at
    self.last_answer_info["teacher_id"]    = answer.teacher.id
    self.learning_plan.update_answered_questions_count(self)
    self.save
    reload
  end

  def is_first_answered?
    # 如果以前从没被回答过
    return true if self.last_answer_info_was.empty? and not self.last_answer_info.empty?
  end

  def is_first_answered_by_the_teacher?(teacher_id)
    # 最后一次回答此问题的teacher是否头一次回答此问题
    if self.last_answer_info["teacher_id"] == teacher_id and
        not self.answers_info_was[teacher_id.to_s] and
          self.answers_info[teacher_id.to_s] == true
        return true
    end
  end

  def build_a_answer(teacher_id,attributes={})
    a                 = self.answers.build(attributes)
    a.teacher_id      = teacher_id
    a.token           = self.token
    a
  end
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Question.where(token: random_token).size == 0
    end
  end
private
  def update_picture_info
    Picture.update_imageable_info(self)
  end
end
