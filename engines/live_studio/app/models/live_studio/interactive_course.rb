module LiveStudio
  class InteractiveCourse < ActiveRecord::Base
    acts_as_taggable
    has_soft_delete

    include AASM
    extend Enumerize
    include Channelable
    include LiveCommon

    include Qatime::Stripable
    strip_field :name, :description

    include Qatime::Discussable

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::InteractivePublicizeUploader

    enum status: {
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3, # 已结束
      refunded: 99 # 已结束 退款
    }
    enumerize :status, in: {
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3, # 已结束
      refunded: 99 # 已结束 退款
    }

    aasm column: :status, enum: true do
      state :init
      state :published, initial: true
      state :teaching
      state :completed
      state :refunded

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

      event :refund do
        transitions from: [:teaching], to: :refunded
      end
    end

    # 初始状态 直接开课
    default_value_for :status, InteractiveCourse.statuses[:published]
    before_create do
      self.published_at = Time.now
      self.class_date = interactive_lessons.map(&:class_date).try(:min)
    end

    belongs_to :workstation
    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: '::User'

    has_many :interactive_lessons, dependent: :destroy
    has_many :lessons, dependent: :destroy, class_name: 'InteractiveLesson', foreign_key: :interactive_course_id
    has_many :teachers, -> { distinct }, through: :interactive_lessons

    has_many :tickets, as: :product # 听课证
    has_many :buy_tickets, as: :product, class_name: 'LiveStudio::BuyTicket'
    has_many :students, through: :buy_tickets

    has_many :announcements, as: :announcementable
    has_many :live_studio_interactive_course_notifications, as: :notificationable, dependent: :destroy

    validates :name, presence: true, length: { in: 2..20 }
    validates :description, presence: true, text_length: { in: 5..300 }, if: :description_changed?
    validates :grade, :subject, :workstation_id, presence: true
    validates :price, presence: true, numericality: { greater_than: :price_min, less_than_or_equal_to: 999_999 }
    validates :teacher_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }
    validates :objective, presence: true, length: { in: 1..300 }, if: :objective_changed?
    validates :suit_crowd, presence: true, length: { in: 1..300 }, if: :suit_crowd_changed?

    accepts_nested_attributes_for :interactive_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    validates_associated :interactive_lessons
    validates :interactive_lessons, presence: true
    validate :interactive_lessons_uniq

    scope :uncompleted, -> { where('live_studio_interactive_courses.status < ?', statuses[:completed]) }
    scope :published_start, -> { where('live_studio_interactive_courses.status > ?', statuses[:init]) }
    scope :for_sell, -> { where(status: statuses[:published], buy_tickets_count: 0) }
    scope :finished, -> { where(status: statuses.values_at(:completed, :refunded)) }

    before_create do
      self.service_price = workstation.service_price if workstation
    end

    # 课程日期不能重复
    def interactive_lessons_uniq
      interactive_lessons.each do |lesson|
        lesson.errors.add(:class_date, I18n.t('view.live_studio/interactive_course.validate.class_date_uniq')) if interactive_lessons.find_all{ |x| x.class_date == lesson.class_date }.size > 1
      end
      errors.add(:interactive_lessons, 'interactive_lessons valid error') if interactive_lessons.map(&:errors).any? {|x| x.any? }
    end

    def teacher
      teachers.first
    end

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def distance_days
      today = Date.today
      return 0 if class_date.blank? || class_date < today
      (class_date.to_time - today.to_time) / 60 / 60 / 24
    end

    def current_price
      price.to_f
    end

    # 已下架
    def off_shelve?
      buy_tickets_count > 0
    end

    # 试听数量 超过课程数 不能试听
    def taste_overflow?
      false
    end

    def order_params
      { total_amount: current_price, amount: current_price, product: self }
    end

    # 剩余直播课程数量
    def left_lessons_count
      [interactive_lessons_count - finished_lessons_count, 0].max
    end

    # 订单校验
    def validate_order(order)
      user = order.user
      order.errors[:product] << '课程目前不对外招生' unless for_sell?
      order.errors[:product] << '课程只对学生销售' unless user.student?
      order.errors[:product] << '您已经购买过该课程' if buy_tickets.available.where(student_id: user.id).exists?
    end

    # 发货
    def deliver(order)
      ticket_price = order.amount.to_f / left_lessons_count
      check_ticket!(order)
      ticket = buy_tickets.create(student_id: order.user_id, lesson_price: ticket_price,
                                  payment_order_id: order.id, buy_count: left_lessons_count,
                                  status: 'inactive', item_targets: interactive_lessons.where(live_end_at: nil))
      ticket.active!
      teach!
      ready_lessons
      ticket
    end

    def for_sell?
      published? && buy_tickets_count.zero?
    end

    # 用户是否已经购买
    def own_by?(user)
      return false unless user.present?
      user.live_studio_tickets.available.map(&:course_id).include?(id)
    end

    # 已经购买
    def bought_by?(user)
      return false unless user.present?
      buy_tickets.available.where(student_id: user.id).exists?
    end

    # 试听结束
    def tasted?(_user)
      false
    end

    # 正在试听
    def tasting?(_user)
      false
    end

    # 是否可以试听
    def can_taste?(_user)
      false
    end

    # 是否卖给用户
    def sell_to?(user)
      user.student? && buy_tickets.blank?
    end

    def short_description(len = 20)
      description.try(:truncate, len)
    end

    # 观看授权
    def play_authorize(user, _lesson)
      user.student? ? student_authorize(user) : others_authorize(user)
    end

    # 当前直播课程
    def current_lesson
      return @current_lesson if @current_lesson.present?
      @current_lesson = interactive_lessons.find {|l| l.class_date.try(:today?) }
      @current_lesson ||= interactive_lessons.find {|l| l.class_date > Date.today }
      @current_lesson ||= interactive_lessons.last
      @current_lesson
    end

    def current_lesson_name
      current_lesson.try(:name)
    end

    # 课程单价
    def lesson_price
      return 0 unless interactive_lessons.to_i > 0
      (price.to_f / interactive_lessons).round(2)
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
      coupon.coupon_amount(amount).to_f
    end

    def service_price
      base_price.to_i
    end

    def ready_lessons
      tmp_class_date = [class_date, interactive_lessons.map(&:class_date).min].min rescue class_date
      return if tmp_class_date.blank?
      return if tmp_class_date > Date.today
      teaching! if published?
      interactive_lessons.where(status: [-1, 0]).where('class_date <= ?', Date.today).map(&:ready!)
    end

    def lessons_count
      interactive_lessons_count
    end

    def live_start_time
      lesson = interactive_lessons.reorder('class_date asc,id').first
      lesson.try(:live_start_at).try(:strftime,'%Y-%m-%d %H:%M') ||
        "#{lesson.try(:class_date).try(:strftime)} #{lesson.try(:start_time)}"
    end

    def live_end_time
      lesson = interactive_lessons.reorder('class_date asc,id').last
      lesson.try(:live_end_at).try(:strftime,'%Y-%m-%d %H:%M') ||
        "#{lesson.try(:class_date).try(:strftime)} #{lesson.try(:end_time)}"
    end

    def order_lessons
      interactive_lessons.unscope(:order).includes(:teacher).order(:class_date, :live_start_at, :live_end_at)
    end

    # 是否可退款
    def can_refund?
      teaching?
    end

    def is_finished?
      %w[completed refunded].include?(status)
    end

    def video_lessons_count_of(teacher)
      interactive_lessons.select { |l| l.teacher_id == teacher.id }.count
    end

    # 随时可退
    def refund_any_time?
      true
    end

    # 报名立减
    def coupon_free?
      true
    end

    # 限时打折
    def cheap_moment?
      false
    end

    # 插班优惠?
    def join_cheap?
      false
    end

    def teacher_id
      teacher.try(:id)
    end

    # 调整报名人数(虚数)
    def adjust_users(count)
      self.class.update_counters(id, adjust_tickets_count: count)
      self.class.update_counters(id, users_count: count)
      reload
    end

    # 增加报名人数(真实数)
    def inc_buy_tickets_count
      self.class.increment_counter(:buy_tickets_count, id)
      self.class.increment_counter(:users_count, id)
      reload
    end

    private

    def check_ticket!(order_or_user)
      user = order_or_user.is_a?(Payment::Order) ? order_or_user.user : order_or_user
      ticket = buy_tickets.available.find_by(student_id: user.id)
      raise Payment::DuplicateOrderError, "不可重复购买" if ticket # 重复购买
      # taste_tickets.where(student_id: user.id).available.map(&:replaced!) # 替换正在使用的试听券
    end

    # 教师分成最大值
    def teacher_percentage_max
      100 - publish_percentage - platform_percentage
    end

    # 根据工作站信息设置城市信息
    before_validation :copy_info!, on: :create
    def copy_info!
      return unless workstation
      self.city = workstation.city
      self.province = city.try(:province)
      self.base_price = workstation.service_price.round(2)
    end

    # 计算结账分成
    before_validation :calculate_billing_percentage!
    def calculate_billing_percentage!
      return if workstation.blank?
      if new_record?
        self.publish_percentage = workstation.publish_percentage
        self.publish_percentage = workstation.publish_percentage
      end
      return unless teacher_percentage.present?
      self.sell_and_platform_percentage = 100 - teacher_percentage - publish_percentage
    end

    # 学生授权播放
    def student_authorize(user)
      tickets.available.find_by(student_id: user.id)
    end

    # 教师授权播放
    def others_authorize(user)
      return true if user.admin?
      return teacher_ids.include?(user.id) if user.teacher?
      !user.student? && (workstation_id == user.workstation_id || workstation_id == user.default_workstation.try(:id))
    end

    # 最低价格
    def price_min
      interactive_lessons.size.to_i * 9
    end

    after_commit :notice_teacher_for_assign, on: :create
    def notice_teacher_for_assign
      teachers.each do |t|
        ::LiveStudioInteractiveCourseNotification.find_or_create_by(from: workstation, receiver: t, notificationable: self, action_name: :assign)
      end
    end

    after_create do
      teachers.each do |t|
        t.increment!(:all_courses_count) if t
      end
    end

    # 不初始化摄像头推流地址
    def init_camera_channels; end
  end
end
