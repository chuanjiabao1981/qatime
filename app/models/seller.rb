class Seller < User
  default_scope {where(role: 'seller')}

  belongs_to :workstation
  has_many :live_studio_courses, through: :workstation

  def initialize(attributes = {})
    super(attributes)
    self.role = "seller"
  end

  # 为了和manager一样统一操作
  def workstations
    [workstation].compact
  end
end
