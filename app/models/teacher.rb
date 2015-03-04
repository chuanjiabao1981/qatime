class Teacher < User
  default_scope {where(role: 'teacher')}

  validates_presence_of :subject,:category
  has_many :groups

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end
end