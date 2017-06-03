class Seller < User
  default_scope { where(role: 'seller') }

  belongs_to :workstation
  has_many :customized_courses, through: :workstation
  has_many :live_studio_courses, through: :workstation
  has_many :cities, through: :workstation

  validates :workstation_id, presence: true

  validates :login_mobile, presence: true, length: { is: 11 }, numericality: { only_integer: true }
  validates :name, presence: true, length: { in: 1..7 }
  validates :email, presence: true, format: { with: User::VALID_EMAIL_REGEX }, uniqueness: true

  def initialize(attributes = {})
    super(attributes)
    self.role = "seller"
  end

  # 为了和manager一样统一操作
  def workstations
    [workstation].compact
  end
end
