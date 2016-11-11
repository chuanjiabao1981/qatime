module LiveStudio
  class CourseInvitation < ::Invitation
    attr_accessor :expited_day, :login_mobile

    validates :teacher_percent, presence: true, numericality: {greater_than_or_equal_to: 70, less_than_or_equal_to: 100}, on: :create
    validates :expited_at, presence: true, on: :create
    validates :login_mobile, presence: true, length: { is: 11 }, numericality: { only_integer: true }, on: :create
    validates :expited_day, presence: true, numericality: {only_integer:true}, on: :create

    validate :presence_user, on: :create

    has_one :course, foreign_key: :invitation_id

    def expited_day_display
      second = expited_at.to_i - Time.now.to_i
      second >= 24.hours ? second/24.hours : 1
    end

    def generate_attribute(params)
      teacher = ::Teacher.find_by(login_mobile: params[:login_mobile])
      self.user_id = teacher.try(:id)
      self.expited_at = Time.now+ params[:expited_day].to_i.days
      self.target = inviter.workstations.first
      self.status = CourseInvitation.statuses['sent']
    end

    private

    def presence_user
      errors.add(:login_mobile, '用户不存在') if self.user.blank?
    end

  end
end
