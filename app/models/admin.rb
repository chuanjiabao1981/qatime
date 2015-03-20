class Admin < User
  has_many :recharge_codes

  default_scope {where(role: 'admin')}

  def initialize(attributes = {})
    super(attributes)
    self.role = "admin"
  end
end