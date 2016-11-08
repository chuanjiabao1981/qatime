class ManagerInviation < Inviation
  attr_accessor :expited_day, :parent_phone

  validates :teacher_percent, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, on: :create
  validates :user_id, presence: true, numericality: { only_integer: true }, on: :create
  validates :expited_at, presence: true, on: :create
  validates :parent_phone, presence: true, length: { is: 11 }, numericality: { only_integer: true }, on: :create
  validates :expited_day, presence: true, numericality: {only_integer:true}, on: :create

  def created_date_display
    created_at.strftime('%F %T')
  end

  def user_phone
    user.try(:parent_phone)
  end

  def expited_day_display
    second = expited_at.to_i - Time.now.to_i
    second >= 24.hours ? second/24.hours : 1
  end

  def generate_attribute(params)
    teacher = Teacher.find_by(parent_phone: params[:parent_phone])
    self.user_id = teacher.try(:id)
    self.expited_at = Time.now+ params[:expited_day].to_i.days
    self.target_type = Workstation.name
    self.target_id = self.inviter.workstations.sample.id
    self.status = ManagerInviation.statuses['sent']
  end

end
