class Manager < User
  default_scope {where(role: 'manager')}

  belongs_to :workstation

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end

end