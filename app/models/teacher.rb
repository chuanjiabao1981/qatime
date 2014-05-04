class Teacher < User
  default_scope {where(role: 'teacher')}

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end
end