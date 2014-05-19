class Student < User
  default_scope {where(role: 'student')}
  has_many :groups

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end
end