module LiveStudio
  class Course < ActiveRecord::Base
    acts_as_taggable

    # include LiveStudio::QaCourseActionRecord
    has_soft_delete
    attr_accessor :sell_percentage_range

    include AASM
    extend Enumerize

    include Qatime::Stripable
    strip_field :name, :description
    include Qatime::Discussable

    SYSTEM_FEE = 0.6 # 系统每个人每分钟收费0.6元
    WORKSTATION_PERCENT = 0.6 # 基础服务费代理商分成 60%

    USER_STATUS_BOUGHT = :bought # 已购买
    USER_STATUS_TASTING = :tasting # 正在试听
    USER_STATUS_TASTED = :tasted # 已经试听

    DEFAULT_TEACHER_PERCENTAGE = 80

    belongs_to :invitation
    # 维护比较复杂，暂时不使用
    # belongs_to :current_lesson, class_name: 'Lesson'

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

    # enumerize排序优先级会影响到enum 必须放在后面加载
    enumerize :sell_percentage_range, in: %w[low middle high]

    aasm column: :status, enum: true do
      state :rejected
      state :init, initial: true
      state :published
      state :teaching
      state :completed

      event :reject do
        transitions from: :init, to: :rejected
      end

      event :publish, after_commit: :ready_lessons do
        before do
          self.published_at = Time.now
          self.billing_type = 'Payment::LiveCourseBilling'
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

    validates :publish_percentage, :platform_percentage, :sell_and_platform_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :teacher_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }

    validate :check_billing_percentage

    # validates :preset_lesson_count, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 200 }
    validates :price, numericality: { greater_than_or_equal_to: :lower_price, message: "必须大于等于0" }
    validates :price, presence: { message: "请输入价格" }, numericality: { greater_than: :lower_price, less_than_or_equal_to: 999_999 }

    validates :taste_count, numericality: { greater_than_or_equal_to: 0, message: "必须大于等于0" }
    validates :taste_count, numericality: { less_than: ->(record) { record.lessons.size }, message: '必须小于课程总数'}

    validates :teacher, presence: true
    # validates :publicize, presence: { message: "请添加图片" }, on: :create
    validates :objective, presence: true, length: { in: 1..50 }, if: :objective_changed?
    validates :suit_crowd, presence: true, length: { in: 1..30 }, if: :suit_crowd_changed?

    belongs_to :teacher, class_name: '::Teacher'

    belongs_to :workstation

    has_many :tickets, as: :product# 听课证
    has_many :buy_tickets, -> { where.not(status: LiveStudio::Ticket.statuses[:refunded]) }, as: :product # 普通听课证
    has_many :taste_tickets # 试听证
    has_many :lessons, -> { order('id asc') }
    has_many :live_sessions, through: :lessons
    has_many :course_requests, dependent: :destroy
    has_many :live_studio_course_notifications, as: :notificationable, dependent: :destroy

    accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    validates_associated :lessons
    validates :lessons, presence: { message: '请添加至少一节课程' }

    has_many :students, through: :buy_tickets

    has_many :channels
    has_many :push_streams, through: :channels
    has_many :pull_streams, through: :channels
    has_many :play_records # 听课记录
    has_many :announcements, as: :announcementable
    has_many :qr_codes, as: :qr_codeable, class_name: "::QrCode"

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
    scope :by_city, ->(city_id) { where(city_id: city_id) }
    scope :class_date_sort, ->(class_date_sort){ class_date_sort && class_date_sort == 'desc' ? order(class_date: :desc) : order(:class_date)}
    scope :uncompleted, -> { where('status < ?', Course.statuses[:completed]) }
    scope :opening, ->{ where(status: [Course.statuses[:teaching], Course.statuses[:completed]]) }
    scope :for_sell, -> { where(status: [Course.statuses[:teaching], Course.statuses[:published]]) }

    def cant_publish?
      !init? || lessons_count <= 0 || name.blank? || description.blank?
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

    def teachers
      [teacher].compact
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
      [lessons_count - finished_lessons_count, 0].max
    end

    def left_lessons_count
      [lessons_count - finished_lessons_count, 0].max
    end

    # 当前价格
    def current_price
      return 0 if lessons_count <= closed_lessons_count
      return price.to_f if closed_lessons_count.zero?
      lesson_price * (lessons_count - closed_lessons_count)
    end

    def live_next_time
      lesson = lessons.include_today.unstart.first
      lesson && "#{lesson.class_date} #{lesson.start_time}-#{lesson.end_time}" || I18n.t('view.course_show.nil_data')
    end

    # 发货
    def deliver(order)
      taste_tickets.where(student_id: order.user_id).available.map(&:replaced!) # 替换正在使用的试听券
      ticket_price = lesson_count_left.zero? ? order.amount : order.amount.to_f / lesson_count_left
      ticket = buy_tickets.nonescope.find_or_create_by(student_id: order.user_id, lesson_price: ticket_price,
                                             payment_order_id: order.id, buy_count: lesson_count_left)
      ticket.got_lesson_ids = lessons.where(live_end_at: nil).map(&:id)
      ticket.active!
    end

    def for_sell?
      published? || teaching?
    end

    # 用户是否已经购买
    def own_by?(user)
      return false unless user.present?
      user.live_studio_tickets.find {|t| t.product_id == id && t.product_type == 'LiveStudio::Course' }.present?
    end

    # 已经购买
    def bought_by?(user)
      return false unless user.present?
      user.live_studio_buy_tickets.find {|t| t.product_id == id && t.product_type == 'LiveStudio::Course' }.present?
    end

    # 试听结束
    def tasted?(user)
      return false unless user.present?
      taste_tickets.unavailable.where(student_id: user.id).exists?
    end

    # 正在试听
    def tasting?(user)
      return false unless user.present?
      user.live_studio_buy_tickets.find {|t| t.product_id == id && t.product_type == 'LiveStudio::Course' }.present?
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
    def reset_completed_lessons_count!
      teached_count = lessons.teached.count
      update_attributes!(finished_lessons_count: teached_count, completed_lessons_count: teached_count)
    end

    # 是否可以结课
    def ready_for_close?
      teaching? && finished_lessons_count >= lessons_count
    end

    # 当前直播课程
    def current_lesson
      return @current_lesson if @current_lesson.present?
      @current_lesson ||= lessons.find {|l| l.class_date.try(:today?) && l.unclosed? }
      @current_lesson ||= lessons.select {|l| l.class_date.try(:today?) }.last
      @current_lesson ||= lessons.find {|l| l.class_date > Date.today && l.unclosed? }
      @current_lesson ||= lessons.select {|l| l.class_date.present? }.last
    end

    def live_status
      return 'none' unless current_lesson
      case current_lesson.status
      when 'missed'
        'init'
      when 'init'
        'init'
      when 'ready'
        'ready'
      when 'teaching'
        'teaching'
      when 'paused'
        'teaching'
      else
        'closed'
      end
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
      (price.to_f / lessons_count).round(2)
    end

    def self.status_options
      Course.statuses.map {|k, v| [LiveStudio::Course.human_attribute_name("aasm_state/#{k}"), v] }
    end

    # 招生申请 提交审核
    after_commit :apply_publish, on: :create
    def apply_publish
      course_requests.create(user: teacher, workstation: workstation)
    end

    def ready_lessons
      return unless class_date <= Date.today
      teaching! if published?
      lessons.where(status: [-1, 0]).where('class_date <= ?', Date.today).map(&:ready!)
    end

    # 购买人数
    def buy_user_count
      buy_tickets_count + adjust_buy_count
    end

    # 经销商推广辅导班 优惠码购买 生成二维码链接
    # course_id coupon_id 2个条件唯一
    def generate_qrcode_by_coupon(coupon_code)
      coupon = ::Payment::Coupon.find_by(code: coupon_code)
      return if coupon.blank?

      course_buy_url = "#{$host_name}/wap/live_studio/courses/#{self.id}?come_from=weixin&coupon_code=" + coupon.code
      qr_code = self.qr_codes.by_coupon(coupon.id).try(:first)
      return qr_code.code_url if qr_code.present?

      relative_path = ::QrCode.generate_tmp(course_buy_url)
      tmp_path = Rails.root.join(relative_path)
      qr_code = self.qr_codes.new(coupon_id: coupon.id)
      File.open(tmp_path) do |file|
        qr_code.code = file
      end
      qr_code.save
      File.delete(tmp_path)
      qr_code.code_url
    end

    # 计算经销分成
    def sell_percentage_for(seller)
      [(sell_and_platform_percentage - seller.platform_percentage), 0].max
    end

    def coupon_price(coupon = nil)
      return current_price.to_f unless coupon.present?
      [current_price.to_f - coupon.price, 0].max
    end

    def service_price
      (base_price.to_f * 60).to_i
    end

    def reset_left_price
      self.left_price = current_price
      save
    end

    private

    # 辅导班删除以后同时删除课程
    after_commit :clear_lessons
    def clear_lessons
      lessons.map(&:destroy) unless deleted_at.blank?
    end

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

    # 结账比例验证
    def check_billing_percentage
      errors.add(:teacher_percentage, "分成比例不正确") unless 100 == publish_percentage + sell_and_platform_percentage + teacher_percentage
    end

    # 教师分成最大值
    def teacher_percentage_max
      100 - publish_percentage - platform_percentage
    end

    after_commit :finish_invitation, on: :create
    def finish_invitation
      invitation.accepted! if invitation
    end

    # 从教师记录复制辅导班信息
    before_validation :copy_info, on: :create
    def copy_info
      self.teacher = author unless teacher_id
      self.subject = teacher.try(:subject)
    end

    def copy_workstation_info
      # 邀请创建的辅导班工作站使用邀请者的工作站
      copy_invitation_info! if invitation
      # 没有工作站的辅导班使用老师的默认工作站
      self.workstation ||= default_workstation
      copy_city!
    end

    # 处理邀请
    def copy_invitation_info!
      return unless invitation
      self.workstation = invitation.target
      self.teacher_percentage = invitation.teacher_percent
    end

    # 根据工作站信息设置城市信息
    def copy_city!
      self.city = workstation.try(:city)
      self.city ||= author.city # 工作站不存在使用老师的城市
      self.province = city.try(:province)
    end

    # 默认工作站
    def default_workstation
      author.city.try(:workstations).try(:first)
    end

    def copy_billing_percentage
      tpl_workstation = workstation || Workstation.default
      # 发行分成
      self.publish_percentage = tpl_workstation.publish_percentage
      # 平台分成
      self.platform_percentage = tpl_workstation.platform_percentage
      self.base_price = (tpl_workstation.service_price / 60.0).round(2)
    end

    # 计算结账分成
    before_validation :calculate_billing_percentage!
    def calculate_billing_percentage!
      return unless teacher_percentage.present?
      if new_record?
        copy_workstation_info
        copy_billing_percentage
      end
      self.sell_and_platform_percentage = 100 - teacher_percentage - publish_percentage
    end

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
