class Teacher < User
  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end
end