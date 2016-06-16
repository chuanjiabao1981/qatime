class Manager < User
  default_scope {where(role: 'manager')}

  has_many :workstations

  has_many :selles
  has_many :waiters

  has_many :live_studio_courses, through: :workstations

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end
end
