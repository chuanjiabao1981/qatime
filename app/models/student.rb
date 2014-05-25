class Student < User
  default_scope {where(role: 'student')}
  has_many :groups
  has_many :recharge_records

  def initialize(attributes = {})
    super(attributes)
    self.role = "student"
  end

  def recharge(code)
    raise '充值码不存在'
  end
end