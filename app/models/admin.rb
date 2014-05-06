class Admin < User
  def initialize(attributes = {})
    super(attributes)
    self.role = "admin"
  end
end