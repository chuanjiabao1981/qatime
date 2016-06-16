class Seller < User
  default_scope {where(role: 'seller')}

  belongs_to :workstation
  has_many :live_studio_courses, through: :workstation

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end
end
