class Manager < User
  default_scope { where(role: 'manager') }

  belongs_to :city
  has_many :workstations

  def initialize(attributes = {})
    super(attributes)
    self.role = 'manager'
  end
end
