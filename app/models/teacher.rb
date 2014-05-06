class Teacher < User
  default_scope {where(role: 'teacher')}
  has_many :groups

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end
end