class Waiter < User
  default_scope {where(role: 'waiter')}

  belongs_to :workstation
  has_many :customized_courses, through: :workstation
  has_many :live_studio_courses, through: :workstation
  validates :workstation_id, presence: true
  has_many :cities, through: :workstation

  def initialize(attributes = {})
    super(attributes)
    self.role = "waiter"
  end

end
