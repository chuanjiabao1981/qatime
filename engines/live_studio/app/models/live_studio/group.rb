module LiveStudio
  class Group < ActiveRecord::Base
    has_soft_delete

    include AASM
    extend Enumerize
    include QaToken
    include LiveCommon
    include Channelable
    include Ticketable
    include Qatime::Discussable
    include Qatime::Stripable
    include Resource::Quotable
    include Taskable
    strip_field :name, :description

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
      completed: 3, # 已结束
      waiting: 11 # 待开课
    }

    # enumerize排序优先级会影响到enum 必须放在后面加载
    enumerize :sell_type, in: { charge: 1, free: 2 }, scope: true

    aasm column: :status, enum: true do
      state :rejected
      state :init, initial: true
      state :published
      state :teaching
      state :completed
      state :waiting

      event :reject do
        transitions from: :init, to: :rejected
      end

      # 开始招生
      event :publish, after_commit: :ready_lessons do
        before do
          self.published_at = Time.now
        end
        transitions from: :init, to: :published
      end

      # 开始上课
      event :teach do
        transitions from: [:published, :waiting], to: :teaching
      end

      # 结束课程
      event :complete do
        transitions from: :teaching, to: :completed
      end
    end

    # 初始状态 直接开课
    default_value_for :status, Group.statuses[:published]
    before_create do
      self.published_at = Time.now
      self.start_at = (scheduled_lessons + offline_lessons).map(&:class_date).try(:min)
    end
    after_commit :ready_lessons, on: :create

    validates :name, presence: true, length: { in: 2..20 }, if: :name_changed?
    validates :description, presence: true, text_length: { in: 5..300 }, if: :description_changed?
    validates :grade, presence: true, if: :grade_changed?
    validates :subject, presence: true, if: :subject_changed?

    validates :publish_percentage, :platform_percentage, :sell_and_platform_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :teacher_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }

    validate :check_billing_percentage

    validates :price, numericality: { greater_than_or_equal_to: :lower_price }
    validates :price, presence: true

    validates :teacher, presence: true
    validates :objective, presence: true, length: { in: 1..300 }, if: :objective_changed?
    validates :suit_crowd, presence: true, length: { in: 1..300 }, if: :suit_crowd_changed?

    validates :max_users, presence: true, inclusion: { in: 6..10 }

    belongs_to :teacher, class_name: '::Teacher'
    belongs_to :workstation

    has_many :events, -> { order('id asc') }
    has_many :lessons, dependent: :destroy, class_name: 'LiveStudio::Event', foreign_key: :group_id
    has_many :announcements, as: :announcementable
    has_many :qr_codes, as: :qr_codeable, class_name: "::QrCode"
    has_many :live_studio_group_notifications, as: :notificationable, dependent: :destroy

    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: User

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::GroupPublicizeUploader

    scope :sell_and_platform_percentage_greater_than, ->(platform_percentage) { where('live_studio_groups.sell_and_platform_percentage > ?', platform_percentage) }
    scope :uncompleted, -> { where('live_studio_groups.status < ?', statuses[:completed]) }
    scope :for_sell, -> { where(status: statuses.values_at(:published, :teaching)) }

    def for_sell?
      published? || teaching?
    end

    def sell_out?
      users_count >= max_users
    end

    def teacher_name
      teacher.try(:name)
    end

    def teachers
      [teacher].compact
    end

    def ready_lessons
      tmp_class_date = events.map(&:class_date).compact.min
      tmp_class_date ||= (scheduled_lessons + offline_lessons).map(&:class_date).try(:min)
      return if tmp_class_date.blank?
      return if tmp_class_date > Date.today
      teaching! if published?

      scheduled_lessons.where(status: [-1, 0]).where('class_date <= ?', Date.today).map(&:ready!)
      offline_lessons.where(status: [-1, 0]).where('class_date <= ?', Date.today).map(&:ready!)
    end

    def distance_days
      today = Date.today
      return 0 if start_at.blank? || start_at < today
      (start_at.to_time - today.to_time) / 60 / 60 / 24
    end

    # 已下架
    def off_shelve?
      completed?
    end

    # 当前价格
    def current_price
      price
    end

    # 购买人数
    def buy_user_count
      users_count
    end

    # 已经购买
    def bought_by?(user)
      return false unless user.present?
      return false unless user.student?
      user.live_studio_buy_tickets.available.find {|t| t.product_id == id && t.product_type == 'LiveStudio::Group' }.present?
    end

    # 随时可退
    def refund_any_time?
      sell_type.charge?
    end

    # 报名立减
    def coupon_free?
      sell_type.charge?
    end

    # 限时打折
    def cheap_moment?
      false
    end

    # 插班优惠?
    def join_cheap?
      teaching? && closed_events_count > 0 && sell_type.charge?
    end

    # 免费试听
    def free_taste?
      taste_count.to_i > 0 && sell_type.charge?
    end

    def self.beat_step
      APP_CONFIG[:live_beat_step] || 10
    end

    # 是否可退款
    def can_refund?
      for_sell?
    end

    def service_price
      base_price.to_i
    end

    # 计算经销分成
    def sell_percentage_for(seller)
      [(sell_and_platform_percentage - seller.platform_percentage), 0].max
    end

    # 经销商推广辅导班 优惠码购买 生成二维码链接
    # course_id coupon_id 2个条件唯一
    def generate_qrcode_by_coupon(coupon_code)
      coupon = ::Payment::Coupon.find_by(code: coupon_code)
      return if coupon.blank?

      course_buy_url = "#{$host_name}/wap/live_studio/#{self.model_name.route_key}/#{self.id}?come_from=weixin&coupon_code=" + coupon.code
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

    # 修正报名人数
    def fix_users_count
      [users_count, max_users].min
    end

    def reset_left_price
      self.left_price = current_price
      save
    end

    private

    # 结账比例验证
    def check_billing_percentage
      errors.add(:teacher_percentage, I18n.t('view.live_studio/course.validates.teacher_percentage')) unless 100 == publish_percentage + sell_and_platform_percentage + teacher_percentage.to_i
    end

    # 教师分成最大值
    def teacher_percentage_max
      100 - publish_percentage - platform_percentage
    end

    def copy_workstation_info
      # 没有工作站的辅导班使用老师的默认工作站
      self.workstation ||= default_workstation
      copy_city!
    end

    # 根据工作站信息设置城市信息
    def copy_city!
      self.city = workstation.try(:city)
      self.city ||= teacher.try(:city) # 工作站不存在使用老师的城市
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
      self.base_price = tpl_workstation.service_price.round(2)
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

    before_validation :check_sell_type
    def check_sell_type
      return unless sell_type.free?
      self.price = 0
      self.taste_count = 0
      self.teacher_percentage = 0
    end

    # 小班课创建通知指定教师
    after_commit :notice_teacher_for_assign, on: :create
    def notice_teacher_for_assign
      ::LiveStudioGroupNotification.find_or_create_by(from: workstation, receiver: teacher, notificationable: self, action_name: :assign)
    end

    after_create do
      teacher.increment!(:all_courses_count) if teacher
    end

    def lower_price
      sell_type.free? ? 0 : 1
    end
  end
end
