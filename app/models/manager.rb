class Manager < User
  default_scope {where(role: 'manager')}

  has_many :workstations

  has_many :sellers, through: :workstations
  has_many :waiters, through: :workstations

  has_many :live_studio_courses, through: :workstations

  has_many :manager_inviations, foreign_key: :inviter_id

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end
end
