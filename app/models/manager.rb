class Manager < User
  default_scope {where(role: 'manager')}

  has_many :workstations
  has_many :cities, through: :workstations

  has_many :sellers, through: :workstations
  has_many :waiters, through: :workstations

  has_many :live_studio_courses, through: :workstations
  has_many :customized_courses, through: :workstations

  has_many :invitations, foreign_key: :inviter_id, class_name: LiveStudio::CourseInvitation
  has_many :course_requests, through: :workstations, class_name: LiveStudio::CourseRequest

  def initialize(attributes = {})
    super(attributes)
    self.role = "manager"
  end
end
