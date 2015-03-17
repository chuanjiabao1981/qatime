class Teacher < User

  default_scope {where(role: 'teacher')}

  validates_presence_of :subject,:category

  has_many :curriculums
  has_many :courses
  has_one  :register_code, dependent: :destroy

  attr_accessor :register_code_value,:tmp_register_code,:accept

  validates_presence_of :register_code_value, on: :create
  validate :register_code_valid, on: :create
  validates :accept, acceptance: true

  after_create :update_register_code

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

  private
  def register_code_valid
    # 这里虽然设置了true使得验证成功后此注册码过期，但是由于如果整体teacher不成成功会rollback，
    # 所以一个正确验证码在teacher其他字段不成功的情况下，同样还是有效的
    self.tmp_register_code = RegisterCode.verification(self.register_code_value,self.school_id,true)
    if not self.tmp_register_code
      errors.add("register_code_value","注册码不正确")
    end
  end

  def update_register_code
    self.tmp_register_code.teacher = self
    self.tmp_register_code.save
  end
end