class Teacher < User
  default_scope {where(role: 'teacher')}

  validates_presence_of :subject,:category
  has_many :curriculums
  has_many :courses

  ## need to be deleted
  has_many :groups
  ## end

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end

  def find_or_create_curriculums
    s = []
    TeachingProgram.where(:category => self.category).each do |teaching_program|
      s.append(Curriculum.find_or_create_by(teacher_id: self.id, teaching_program_id: teaching_program.id))
    end
    s
  end
end