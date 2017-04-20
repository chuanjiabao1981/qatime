module LiveStudio
  class VideoCourse < ActiveRecord::Base
    acts_as_taggable

    # include LiveStudio::QaCourseActionRecord
    has_soft_delete
    attr_accessor :sell_percentage_range
    attr_accessor :context

    include AASM
    extend Enumerize
    include QaToken

    include Qatime::Stripable
    strip_field :name, :description
    include Qatime::Discussable

    USER_STATUS_BOUGHT = :bought # 已购买
    USER_STATUS_TASTING = :tasting # 正在试听
    USER_STATUS_TASTED = :tasted # 已经试听

    enum status: {
           rejected: -1, # 被拒绝
           init: 0, # 初始化 待审核
           confirmed: 1, # 审核通过
           completed: 2, # 已创建
           published: 3 # 已发布
         }

    enumerize :status, in: {
                         rejected: -1, # 被拒绝
                         init: 0, # 初始化
                         confirmed: 1, # 审核通过
                         completed: 2, # 已创建
                         published: 3 # 已发布
                     }

    # enumerize排序优先级会影响到enum 必须放在后面加载
    enumerize :sell_percentage_range, in: %w[low middle high]
    enumerize :sell_type, in: { charge: 1, free: 2 }

    aasm column: :status, enum: true do
      state :rejected
      state :init, initial: true
      state :confirmed
      state :completed
      state :published

      event :reject, after_commit: :reject_notify do
        transitions from: :init, to: :rejected
      end

      event :confirm, after_commit: :confirm_notify do
        before do
          self.confirmed_at = Time.now
        end
        transitions from: :init, to: :confirmed
      end

      event :complete do
        before do
          self.completed_at = Time.now
        end
        transitions from: :confirmed, to: :completed
      end

      event :publish, after_commit: :publish_notify do
        before do
          self.published_at = Time.now
          self.billing_type = 'Payment::LiveCourseBilling'
        end
        transitions from: :completed, to: :published
      end
    end

    validates :name, presence: { message: I18n.t('view.live_studio/course.validates.name') }, length: { in: 2..20 }, if: :name_changed?
    validates :description, presence: { message: I18n.t('view.live_studio/course.validates.description') }, length: { in: 5..300 }, if: :description_changed?
    validates :grade, presence: { message: I18n.t('view.live_studio/course.validates.grade') }, if: :grade_changed?
    validates :subject, presence: { message: I18n.t('view.live_studio/course.validates.subject') }, if: :subject_changed?

    validates :publish_percentage, :platform_percentage, :sell_and_platform_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    validate :check_billing_percentage, if: :context_complete?

    validates :teacher_percentage, :price, presence: true, if: :context_complete?
    validates :teacher_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }, if: :context_complete?
    validates :price, numericality: { greater_than_or_equal_to: :lower_price }

    # validates :price, numericality: { greater_than_or_equal_to: :lower_price, message: I18n.t('view.live_studio/course.validates.price_greater_than_or_equal_to') }
    # validates :price, presence: { message: I18n.t('view.live_studio/course.validates.price') }, numericality: { greater_than: :lower_price, less_than_or_equal_to: 999_999 }

    validates :teacher, presence: true
    # validates :publicize, presence: { message: "请添加图片" }, on: :create
    validates :objective, presence: { message: I18n.t('view.live_studio/course.validates.objective') }, length: { in: 1..50 }, if: :objective_changed?
    validates :suit_crowd, presence: { message: I18n.t('view.live_studio/course.validates.suit_crowd') }, length: { in: 1..30 }, if: :suit_crowd_changed?

    belongs_to :teacher, class_name: '::Teacher'
    belongs_to :workstation

    has_many :tickets, as: :product # 听课证
    has_many :buy_tickets, -> { where.not(status: LiveStudio::Ticket.statuses[:refunded]) }, as: :product # 普通听课证
    has_many :taste_tickets, as: :product # 试听证
    has_many :video_lessons, -> { order('id asc') }
    has_many :live_studio_course_notifications, as: :notificationable, dependent: :destroy
    has_many :qr_codes, as: :qr_codeable, class_name: "::QrCode"

    accepts_nested_attributes_for :video_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    validates_associated :video_lessons
    validates :video_lessons, presence: { message: I18n.t('view.live_studio/course.validates.lessons') }

    has_many :students, through: :buy_tickets

    has_many :play_records # 听课记录
    has_many :qr_codes, as: :qr_codeable, class_name: "::QrCode"

    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: "::User"

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::VideoPublicizeUploader

    scope :month, ->(month) {where('live_studio_video_courses.class_date >= ? and live_studio_video_courses.class_date <= ?',
                                   month.beginning_of_month.to_date,
                                   month.end_of_month.to_date) }
    scope :by_status, ->(status) {status.blank? || status == 'all' ? nil : where(status: VideoCourse.statuses[status.to_sym])}
    scope :by_subject, ->(subject){ subject.blank? || subject == 'all' ? nil : where(subject: subject)}
    scope :by_grade, ->(grade){ grade.blank? || grade == 'all' ? nil : where(grade: grade)}
    scope :by_city, ->(city_id) { where(city_id: city_id) }
    scope :class_date_sort, ->(class_date_sort){ class_date_sort && class_date_sort == 'desc' ? order(class_date: :desc) : order(:class_date)}
    scope :unpublished, -> { where('live_studio_video_courses.status < ?', VideoCourse.statuses[:published]) }
    scope :audited, -> { where(status: VideoCourse.statuses.values_at(:rejected, :confirmed)) }
    scope :no_audit, -> { where(status: VideoCourse.statuses[:init]) }
    scope :for_sell, -> { where(status: VideoCourse.statuses[:published]) }

    def cant_publish?
      !init? || video_lessons_count <= 0 || name.blank? || description.blank?
    end

    def preview!
      self.published_at = Time.now
      super
    end

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def teachers
      [teacher].compact
    end

    def status_audit_text
      I18n.t("view.live_studio/video_course.audits.status_text.#{status}")
    end

    def distance_days
      today = Date.today
      return 0 if class_date.blank? || class_date < today
      (class_date.to_time - today.to_time) / 60 /60 / 24
    end

    def order_params
      { amount: current_price, product: self }
    end

    # 当前价格
    def current_price
      price
    end

    # 发货
    def deliver(order)
      taste_tickets.where(student_id: order.user_id).available.map(&:replaced!) # 替换正在使用的试听券
      ticket = buy_tickets.find_or_create_by(student_id: order.user_id, lesson_price: price,
                                             payment_order_id: order.id, buy_count: video_lessons_count)
      ticket.active!
      # 视频课购买以后直接结账

      LiveStudio::VideoCourseBillingJob.perform_later(ticket.id)
    end

    def for_sell?
      published?
    end

    # 用户是否已经购买
    def own_by?(user)
      return false unless user.present?
      return false unless user.student?
      user.live_studio_tickets.available.find {|t| t.product_id == id && t.product_type == 'LiveStudio::VideoCourse' }.present?
    end

    # 已经购买
    def bought_by?(user)
      return false unless user.present?
      return false unless user.student?
      user.live_studio_buy_tickets.available.find {|t| t.product_id == id && t.product_type == 'LiveStudio::VideoCourse' }.present?
    end

    # 试听结束
    def tasted?(user)
      return false unless user.present?
      return false unless user.student?
      taste_tickets.unavailable.where(student_id: user.id).exists?
    end

    # 正在试听
    def tasting?(user)
      return false unless user.present?
      return false unless user.student?
      user.live_studio_taste_tickets.available.find {|t| t.product_id == id && t.product_type == 'LiveStudio::VideoCourse' }.present?
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

    # 课程单价
    def lesson_price
      return 0 unless video_lessons_count.to_i > 0
      (price.to_f / video_lessons_count).round(2)
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

      course_buy_url = "#{$host_name}/wap/live_studio/video_courses/#{self.id}?come_from=weixin&coupon_code=" + coupon.code
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

    def lessons_count
      video_lessons_count
    end

    def can_refund?
      false
    end

    def reset_total_duration
      self.total_duration = video_lessons.sum(:real_time)
      save
    end

    def duration_minutes
      (total_duration.to_f / 60.0).round(2)
    end

    private

    # 校验上下文, 升级Rails 5之前替代方案
    def context_complete?
      context == 'complete'
    end

    # 辅导班删除以后同时删除课程
    after_commit :clear_lessons
    def clear_lessons
      video_lessons.map(&:destroy) unless deleted_at.blank?
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
      errors.add(:teacher_percentage, I18n.t('view.live_studio/course.validates.teacher_percentage')) unless 100 == publish_percentage + sell_and_platform_percentage + teacher_percentage.to_i
    end

    # 教师分成最大值
    def teacher_percentage_max
      100 - publish_percentage - platform_percentage
    end

    # 从教师记录复制辅导班信息
    before_validation :copy_info, on: :create
    def copy_info
      self.subject = teacher.subject
      self.workstation = teacher.workstation || default_workstation
      self.city = workstation.city
      self.province = city.try(:province)
    end

    # 默认工作站
    def default_workstation
      author.city.try(:workstations).try(:first) || Workstation.default
    end

    def copy_billing_percentage
      # 发行分成
      self.publish_percentage = workstation.publish_percentage
      # 平台分成
      self.platform_percentage = workstation.platform_percentage
      self.base_price = (workstation.service_price / 60.0).round(2)
    end

    # 计算结账分成
    before_validation :calculate_billing_percentage!, if: :context_complete?
    def calculate_billing_percentage!
      return unless teacher_percentage.present?
      self.teacher_percentage = 0 if sell_type.free?
      copy_billing_percentage if publish_percentage.zero?
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

    before_validation :check_sell_type
    def check_sell_type
      self.price = 0 if sell_type.free?
    end

    def lower_price
      return 0 if sell_type.free?
      video_lessons_count.to_i * 5
    end

    # 通知
    def notify(receivers, action_name)
      NotificationPublisherJob.perform_later('LiveStudioVideoCourseNotification', self, receivers, action_name)
    end

    # 审核被拒通知
    def reject_notify
      notify(teacher, 'reject')
    end

    # 审核通过通知
    def confirm_notify
      notify(teacher, 'confirm')
    end

    # 发布招生通知
    def publish_notify
      notify(teacher, 'publish')
    end
  end
end
