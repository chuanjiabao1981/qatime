module LiveStudio
  class Course < ActiveRecord::Base
    # include LiveStudio::QaCourseActionRecord
    has_soft_delete

    include AASM
    extend Enumerize

    def to_param
      "#{id} #{name}".parameterize
    end

    SYSTEM_FEE = 0.5 # 系统每个人每分钟收费0.5元
    WORKSTATION_PERCENT = 0.6 # 基础服务费代理商分成 60%

    USER_STATUS_BOUGHT = :bought # 已购买
    USER_STATUS_TASTING = :tasting # 正在试听
    USER_STATUS_TASTED = :tasted # 已经试听

    belongs_to :invitation

    enum status: {
      rejected: -1, # 被拒绝
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3 # 已结束
    }

    enumerize :status, in: {
      rejected: -1, # 被拒绝
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3 # 已结束
    }

    aasm column: :status, enum: true do
      state :rejected
      state :init, initial: true
      state :published
      state :teaching
      state :completed

      event :reject do
        transitions from: :init, to: :rejected
      end

      event :publish do
        before do
          self.published_at = Time.now
        end
        transitions from: :init, to: :published
      end

      event :teach do
        transitions from: :published, to: :teaching
      end

      event :complete do
        transitions from: :teaching, to: :completed
      end
    end

    validates :name, presence: { message: "请输入辅导班名称" }, length: { in: 2..20 }, if: :name_changed?
    validates :description, presence: { message: "请输入辅导班介绍" }, length: { in: 5..300 }, if: :description_changed?
    validates :grade, presence: { message: "请选择年级" }, if: :grade_changed?
    validates :teacher_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 70, less_than_or_equal_to: 100 }
    # validates :preset_lesson_count, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 200 }
    validates :price, presence: { message: "请输入价格" }, numericality: { greater_than: :lower_price, less_than_or_equal_to: 999_999 }

    validates :taste_count, numericality: { less_than: ->(record) { record.lessons.size }, message: "必须小于课程总数" }

    validates :teacher, presence: true
    validates :publicize, presence: { message: "请添加图片" }, on: :create

    belongs_to :teacher, class_name: '::Teacher'

    belongs_to :workstation

    has_many :tickets       # 听课证
    has_many :buy_tickets   # 普通听课证
    has_many :taste_tickets # 试听证
    has_many :lessons, -> { order('id asc') } # 课时
    has_many :course_requests, dependent: :destroy
    has_many :live_studio_course_notifications, as: :notificationable, dependent: :destroy

    accepts_nested_attributes_for :lessons, allow_destroy: true
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    validates_associated :lessons
    validates :lessons, presence: {message: '请添加至少一节课程'}

    has_many :students, through: :buy_tickets

    has_many :channels
    has_many :push_streams, through: :channels
    has_many :pull_streams, through: :channels
    has_many :play_records # 听课记录

    has_one :chat_team, foreign_key: 'live_studio_course_id', class_name: '::Chat::Team'

    has_many :billings, through: :lessons, class_name: 'Payment::Billing' # 结算记录

    has_many :course_action_records, ->{ order 'created_at desc' }, dependent: :destroy, foreign_key: :live_studio_course_id

    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: User

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::PublicizeUploader

    scope :month, ->(month) {where('live_studio_courses.class_date >= ? and live_studio_courses.class_date <= ?',
      month.beginning_of_month.to_date,
      month.end_of_month.to_date) }
    scope :by_status, ->(status) {status.blank? || status == 'all' ? nil : where(status: Course.statuses[status.to_sym])}
    scope :by_subject, ->(subject){ subject.blank? || subject == 'all' ? nil : where(subject: subject)}
    scope :by_grade, ->(grade){ grade.blank? || grade == 'all' ? nil : where(grade: grade)}
    scope :class_date_sort, ->(class_date_sort){ class_date_sort && class_date_sort == 'desc' ? order(class_date: :desc) : order(:class_date)}
    scope :uncompleted, -> { where('status < ?', Course.statuses[:completed]) }
    scope :opening, ->{ where(status: [Course.statuses[:teaching], Course.statuses[:completed]]) }
    scope :for_sell, -> { where(status: [Course.statuses[:teaching], Course.statuses[:published]]) }

    def cant_publish?
      !init? || preset_lesson_count <= 0 || publicize.blank? || name.blank? || description.blank?
    end

    def preview!
      self.published_at = Time.now
      super
    end

    # 白板推流地址
    def board_push_stream
      push_streams.find {|stream| stream.use_for == 'board' }.try(:address)
    end

    # 白板拉流地址
    def board_pull_stream(protocol = 'rtmp')
      pull_streams.find {|stream| stream.use_for == 'board' && stream.protocol == protocol }.try(:address)
    end

    # 摄像头推流地址
    def camera_push_stream
      push_streams.find {|stream| stream.use_for == 'camera' }.try(:address)
    end

    # 摄像头拉流地址
    def camera_pull_stream(protocol = 'rtmp')
      pull_streams.find {|stream| stream.use_for == 'camera' && stream.protocol == protocol }.try(:address)
    end

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def distance_days
      today = Date.today
      return 0 if class_date.blank? || class_date < today
      (class_date.to_time - today.to_time) / 60 /60 / 24
    end

    def order_params
      { amount: current_price, product: self }
    end

    def status_text
      I18n.t("status.#{status}")
    end

    def init_channel
      return unless channels.blank?
      channels.create(name: "#{name} - 直播室 - #{id} - 白板", course_id: id, use_for: :board)
      channels.create(name: "#{name} - 直播室 - #{id} - 摄像头", course_id: id, use_for: :camera)
    end

    def lesson_count_left
      lessons_count - finished_lessons_count
    end

    # 当前价格
    def current_price
      lesson_price * (lessons_count - finished_lessons_count)
    end

    def live_next_time
      lesson = lessons.include_today.unstart.first
      lesson && "#{lesson.class_date} #{lesson.start_time}-#{lesson.end_time}" || I18n.t('view.course_show.nil_data')
    end

    # 发货
    def deliver(order)
      taste_tickets.where(student_id: order.user_id).available.map(&:replaced!) # 替换正在使用的试听券
      ticket = buy_tickets.find_or_create_by(student_id: order.user_id, lesson_price: lesson_price, buy_count: lesson_count_left)
      ticket.active!
    end

    def for_sell?
      published? || teaching?
    end

    # 用户是否已经购买
    def own_by?(user)
      user.live_studio_tickets.map(&:course_id).include?(id)
    end

    # 已经购买
    def bought_by?(user)
      buy_tickets.where(student_id: user.id).exists?
    end

    # 试听结束
    def tasted?(user)
      taste_tickets.unavailable.where(student_id: user.id).exists?
    end

    # 正在试听
    def tasting?(user)
      taste_tickets.available.where(student_id: user.id).exists?
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
    def play_authorize(user, _lesson)
      user.student? ? student_authorize(user) : others_authorize(user)
    end

    # 更新完成课程数量
    def reset_completed_lesson_count!
      teached_count = lessons.teached.count
      update_attributes!(finished_lessons_count: teached_count, completed_lesson_count: teached_count)
    end

    # 是否可以结课
    def ready_for_close?
      teaching? && finished_lessons_count >= lessons_count
    end

    # 当前直播课程
    def current_lesson
      lessons.today.unclosed.first || lessons.today.last || lessons.since_today.unclosed.first || lessons.last
    end

    def current_lesson_name
      case status.to_s
        when 'preview'
          I18n.t('view.course_show.preview_lesson')
        when 'teaching'
          current_lesson.try(:name)
        when 'completed'
          I18n.t('view.course_show.complete_lesson')
      end || I18n.t('view.course_show.nil_data')
    end

    def live_start_time
      lesson = lessons.reorder('class_date asc,id').first
      lesson.try(:live_start_at).try(:strftime,'%Y-%m-%d %H:%M') ||
        "#{lesson.try(:class_date).try(:strftime)} #{lesson.try(:start_time)}"
    end

    def live_end_time
      lesson = lessons.reorder('class_date asc,id').last
      lesson.try(:live_end_at).try(:strftime,'%Y-%m-%d %H:%M') ||
        "#{lesson.try(:class_date).try(:strftime)} #{lesson.try(:end_time)}"
    end

    def live_start_date
      lessons.map(&:class_date).min
    end

    def live_end_date
      lessons.map(&:class_date).max
    end

    def order_lessons
      lessons.except(:order).order(:class_date, :live_start_at, :live_end_at)
    end

    # 课程单价
    def lesson_price
      return 0 unless lessons_count.to_i > 0
      price / lessons_count
    end

    def self.status_options
      Course.statuses.map {|k, v| [LiveStudio::Course.human_attribute_name("aasm_state/#{k}"), v] }
    end

    # 招生申请 提交审核
    after_commit :apply_publish, on: :create
    def apply_publish
      course_requests.create(user: teacher, workstation: workstation)
    end

    private

    before_save :check_lessons
    def check_lessons
      return if new_record?
    end

    # 空格过滤
    before_validation :strip_text!
    def strip_text!
      name.try(:strip!)
      description.try(:strip!)
    end

    # 处理邀请信息
    before_validation :execute_invitation, on: :create
    def execute_invitation
      return unless invitation
      self.workstation = invitation.target
      self.city = invitation.target.city
      self.province = city.try(:province)
      self.teacher_percentage = invitation.teacher_percent
    end

    after_commit :finish_invitation, on: :create
    def finish_invitation
      return unless invitation
      invitation.accepted!
    end

    # 非邀请辅导班使用默认工作站
    before_validation :copy_city, on: :create
    def copy_city
      return if invitation
      self.workstation = default_workstation
      self.city = workstation.try(:city)
      self.province = city.try(:province)
      self.teacher_percentage = 100
    end

    # 从教师记录复制辅导班信息
    before_validation :copy_info, on: :create
    def copy_info
      self.teacher = author unless teacher_id
      self.subject = teacher.try(:subject)
    end

    # 默认工作站
    def default_workstation
      author.city.try(:workstations).try(:first)
    end

    # before_validation :calculate_lesson_price, on: :create
    # def calculate_lesson_price
    #   self.lesson_price = (price / lessons.count).to_i if lessons.count > 0
    # end

    # 学生授权播放
    def student_authorize(user)
      tickets.available.find_by(student_id: user.id)
    end

    # 教师授权播放
    def others_authorize(user)
      return true if user.admin?
      return user.id == teacher_id if user.teacher?
      !user.student? && workstation_id == user.workstation_id
    end

    after_create :init_channel_job
    def init_channel_job
      init_channel
      # ChannelCreateJob.perform_later(id)
    end

    # 辅导班创建通知指定教师
    after_commit :notice_teacher_for_assign, on: :create
    def notice_teacher_for_assign
      ::LiveStudioCourseNotification.create(from: workstation, receiver: teacher, notificationable: self, action_name: :assign)
    end

    def lower_price
      lp = 0
      lp = lessons.size * 5 if lessons.size > 0
      lp
    end
  end
end
