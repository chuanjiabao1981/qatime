class Admin < User
  has_many :recharge_codes
  def initialize(attributes = {})
    super(attributes)
    self.role = "admin"
  end
end