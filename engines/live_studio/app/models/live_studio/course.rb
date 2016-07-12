module LiveStudio
  class Course < ActiveRecord::Base
    has_soft_delete

    SYSTEM_FEE = 0.1 # 系统每个人每分钟收费

    USER_STATUS_BOUGHT = :bought # 已购买
    USER_STATUS_TASTING = :tasting # 正在试听
    USER_STATUS_TASTED = :tasted # 已经试听

    enum status: {
           init: 0, # 初始化
           preview: 1, # 招生中
           teaching: 2, # 已开课
           completed: 3 # 已结束
         }

    validates :name, :price, presence: true
    validates :teacher_percentage, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
    validates :preset_lesson_count, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 200 }
    validates :price, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 999999}

    validates :workstation, :teacher, presence: true

    belongs_to :teacher, class_name: '::Teacher'

    belongs_to :workstation

    has_many :tickets # 听课证
    has_many :buy_tickets # 普通听课证
    has_many :taste_tickets # 试听证
    has_many :lessons # 课时

    has_many :students, through: :buy_tickets

    has_many :channels
    has_many :push_streams, through: :channels
    has_many :pull_streams, through: :channels
    has_many :play_records #听课记录

    has_one :chat_team, foreign_key: 'live_studio_course_id', class_name: '::Chat::Team'

    has_many :billings, through: :lessons, class_name: 'Payment::Billing' # 结算记录

    def push_stream
      push_streams.last
    end

    def pull_stream
      pull_streams.last
    end

    scope :for_sell, -> { where(status: [Course.statuses[:preview], Course.statuses[:teaching]]) }

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def order_params
      { total_money: price, product: self }
    end

    def status_text
      I18n.t("status.#{status}")
    end

    def init_channel
      return unless channels.blank?
      channels.create(name: "#{name} - 直播室 - #{id}", course_id: id)
    end

    # 当前价格
    def current_price
      lesson_price * (preset_lesson_count - completed_lesson_count)
    end

    # 发货
    def deliver(order)
      taste_tickets.where(student_id: order.user_id).available.map(&:replaced!) # 替换正在使用的试听券
      ticket = buy_tickets.find_or_create_by(student_id: order.user_id, lesson_price: lesson_price)
      ticket.active!
    end

    def for_sell?
      preview? || teaching?
    end

    # 用户是否已经购买
    def own_by?(user)
      user.live_studio_tickets.map(&:course_id).include?(id)
    end

    def bought_by?(user)
      buy_tickets.where(student_id: user.id).exists?
    end

    # 用户购买状态
    def status_for(user)
      return USER_STATUS_BOUGHT if buy_tickets.where(student_id: user.id).exists?
      return USER_STATUS_TASTING if taste_tickets.where(student_id: user.id).exists?
      return USER_STATUS_TASTED if taste_tickets.where(student_id: user.id).exists?
    end

    # 是否可以试听
    def can_taste?(user)
      return false unless user.student?
      return false if buy_tickets.where(student_id: user.id).exists?
      !taste_tickets.where(student_id: user.id).exists?
    end

    def tasting?(user)
      taste_tickets.where(student_id: user.id).exists?
    end

    # 是否卖给用户
    def sell_to?(user)
      return false unless user.student? # 辅导班只卖给学生
      return false unless for_sell? # 必须在售中的辅导班
      !bought_by?(user) # 没买过该辅导班才可以购买
    end

    def short_description(len=20)
      description.try(:truncate, len)
    end

    def validate_order(order)
      user = order.user
      order.errors[:product] << '课程目前不对外招生' unless for_sell?
      order.errors[:product] << '课程只对学生销售' unless user.student?
      order.errors[:product] << '您已经购买过该课程' if buy_tickets.where(student_id: user.id).exists?
    end

    # 观看授权
    def play_authorize(user, lesson)
      # 正在观看不需要继续授权
      play_record = play_records.where(user_id: user.id, lesson_id: lesson.id).first
      return play_record if play_record
      return student_authorize(user, lesson) if user.student?
      others_authorize(user, lesson)
    end

    # 更新完成课程数量
    def reset_completed_lesson_count!
      update_attributes!(completed_lesson_count: lessons.teached.count)
    end

    # 是否可以结课
    def ready_for_close?
      teaching? && completed_lesson_count >= preset_lesson_count
    end

    # TODO
    # 当前直播课程
    def current_lesson
      lessons.last
    end

    # 修复辅导班群组及群组成员
    def reset_live_team
      LiveService::CourseDirector.new(self).instance_for_course if chat_team.blank?
      reload

      # 本地查询出的辅导班学生的accid数组
      l_course_accounts = studens.map do |student|
        LiveService::ChatAccountFromUser.new(student).instance_account if student.chat_account.blank?

        student.reload
        student.chat_account.accid
      end

      # 云信服务器的辅导班学生的accid数组
      s_course_accounts = Chat::IM.team_query(chat_team.team_id)['members']

      # 本地比服务器的多，即部分学生没有进入聊天室
      arr_l_s = l_course_accounts - s_course_accounts
      Chat::IM.team_add(chat_team.team_id, chat_team.owner, "#{name} 讨论组", arr_l_s) if arr_l_s.count > 0

      # 服务器比本地的多,即聊天室有非辅导班的学生
      arr_s_l = s_course_accounts -  l_course_accounts
      arr_s_l.each do |accid|
        Chat::IM.team_kick(chat_team.team_id, chat_team.owner, account.accid)
      end if arr_s_l.count > 0
    end

    private

    before_create :set_lesson_price
    def set_lesson_price
      self.lesson_price = (price / preset_lesson_count).to_i if preset_lesson_count.to_i > 0
    end

    # 学生授权播放
    def student_authorize(user, lesson)
      ticket = tickets.authorizable.where(student_id: user.id).first
      return unless ticket
      ticket.active! if ticket.taste? && ticket.inactive?
      ticket.inc_used_count!
      play_records.create(user_id: user.id, lesson_id: lesson.id, ticket: ticket)
    end

    # 教师授权播放
    def others_authorize(user, lesson)
      return if user.teacher? && user.id != teacher_id
      return if self.workstation_id != user.workstation_id
      play_records.create(user_id: user.id, lesson_id: lesson.id)
    end

    after_create :init_channel_job
    def init_channel_job
      init_channel
      # ChannelCreateJob.perform_later(id)
    end
  end
end
