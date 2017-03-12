module LiveStudio
  class CourseInvitation < ::Invitation
    attr_accessor :expited_day, :login_mobile, :user_mobile

    extend Enumerize

    enumerize :status, in: {
      sent: 0, # 已发送
      accepted: 1, # 已接受
      refused: 2, # 已拒绝
      expired: 3, # 已过期
      cancelled: 4, # 已取消
      hidden: 5 # 不显示
    }

    validates :teacher_percent, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max}, on: :create
    validates :expited_at, presence: true, on: :create
    validates :expited_day, presence: true, numericality: {only_integer:true}, on: :create
    validates :user_mobile, presence: true, length: { is: 11 }, numericality: { only_integer: true }, on: :create

    validate :user_mobile_exist

    validates :user, presence: true

    has_one :course, foreign_key: :invitation_id

    def expited_day_display
      second = expited_at.to_i - Time.now.to_i
      second >= 24.hours ? second/24.hours : 1
    end

    def generate_attribute(params)
      self.expited_at = params[:expited_day].to_i.days.since
      self.target = inviter.workstations.first if target.blank?
      self.status = CourseInvitation.statuses['sent']
    end

    # 是否可以手动隐藏
    def can_hide?
      false
    end

    # 是否已经过期
    def expired?
      expited_at && expited_at < Date.today
    end

    private

    before_validation :find_user
    def find_user
      self.user = ::Teacher.find_by(login_mobile: user_mobile) if user_mobile
    end

    def user_mobile_exist
      errors.add(:user_mobile, I18n.t(:"validations.live_studio/course_invitation.user_mobile_not_exist")) unless user.present?
    end

    # 教师分成最大值
    def teacher_percentage_max
      100 - target.publish_percentage - target.platform_percentage
    rescue
      100
    end
  end
end
