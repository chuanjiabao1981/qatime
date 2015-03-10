class Manager < User
  default_scope {where(role: 'manager')}

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end

end