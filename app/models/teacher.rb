class Teacher < User

  default_scope {where(role: 'teacher')}

  validates_presence_of :subject,:category

  has_many :curriculums
  has_many :courses

  has_many :answers
  has_many :learning_plans,:through => :learning_plan_assignments
  has_many :learning_plan_assignments

  belongs_to :school
  attr_accessor :accept

  validates :accept, acceptance: true

  scope :by_category,lambda {|c| where(category: c) if c}
  scope :by_subject, lambda {|s| where(subject: s) if s}

  scope :by_vip_class, lambda{|vip_class| includes(:school).order("schools.name desc").by_subject(vip_class.subject).by_category(vip_class.category) }

  ## need to be deleted
  has_many :groups
  ## end

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


end