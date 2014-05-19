class Student < User
  default_scope {where(role: 'student')}
  has_many :groups
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end
end