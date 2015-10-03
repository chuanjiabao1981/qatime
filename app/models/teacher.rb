class Teacher < User

  default_scope {where(role: 'teacher')}

  validates_presence_of :subject,:category

  has_many :curriculums,dependent: :destroy
  has_many :courses,dependent: :destroy

  has_many :deposits


  has_many :answers,:dependent => :destroy
  has_many :learning_plan_assignments, :dependent => :destroy
  has_many :learning_plans,:through => :learning_plan_assignments

  has_many :customized_course_assignments, :dependent => :destroy
  has_many :customized_courses, :through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  has_many :question_assignments,:dependent => :destroy
  has_many :questions ,:through => :question_assignments

  has_many :corrections
  has_many :replies


  belongs_to :school
  attr_accessor :accept

  validates :accept, acceptance: true

  scope :by_category,lambda {|c| where(category: c) if c}
  scope :by_subject, lambda {|s| where(subject: s) if s}
  scope :by_school,  lambda {|s| where(school_id: s) if s}
  scope :by_vip_class, lambda{|vip_class| includes(:school).order("schools.name desc").by_subject(vip_class.subject).by_category(vip_class.category) }
  scope :by_customized_tutorials, lambda {|c| where(category: c) if c}

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end

  def find_or_create_curriculums
    s = []
    TeachingProgram.where(:category => self.category, :subject => self.subject).order(:created_at).each do |teaching_program|
      s.append(Curriculum.find_or_create_by(teacher_id: self.id, teaching_program_id: teaching_program.id))
    end
    s
  end

  def keep_account
    account = self.account
    CustomizedTutorial.by_teacher(self.id).valid_tally_unit.each do |customized_tutorial|
      customized_tutorial.keep_account(account)
    end

    Correction.by_teacher(self.id).valid_tally_unit.each do |correction|
      correction.keep_account(account)
    end

    Reply.by_teacher(self.id).valid_tally_unit.each do |reply|
      reply.keep_account(account)
    end
  end
end