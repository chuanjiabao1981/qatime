module LiveStudio
  class Group < ActiveRecord::Base
    has_soft_delete

    include AASM
    extend Enumerize
    include QaToken
    include LiveCommon
    include Channelable
    include Ticketable
    include Qatime::Stripable
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
                         completed: 3 # 已结束
                     }

    # enumerize排序优先级会影响到enum 必须放在后面加载
    enumerize :sell_type, in: { charge: 1, free: 2 }, scope: true

    aasm column: :status, enum: true do
      state :rejected
      state :init
      state :published, initial: true
      state :teaching
      state :completed

      event :reject do
        transitions from: :init, to: :rejected
      end

      event :publish, after_commit: :ready_lessons do
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

    # 初始状态 直接开课
    default_value_for :status, Group.statuses[:published]
    before_create do
      self.published_at = Time.now
      self.start_at = events.map(&:class_date).try(:min)
    end
    after_commit :ready_lessons, on: :create

    validates :name, presence: { message: I18n.t('view.live_studio/course.validates.name') }, length: { in: 2..20 }, if: :name_changed?
    validates :description, presence: { message: I18n.t('view.live_studio/course.validates.description') }, length: { in: 5..300 }, if: :description_changed?
    validates :grade, presence: { message: I18n.t('view.live_studio/course.validates.grade') }, if: :grade_changed?
    validates :subject, presence: { message: I18n.t('view.live_studio/course.validates.subject') }, if: :subject_changed?

    validates :publish_percentage, :platform_percentage, :sell_and_platform_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :teacher_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }

    validate :check_billing_percentage

    validates :price, numericality: { greater_than_or_equal_to: :lower_price, message: I18n.t('view.live_studio/course.validates.price_greater_than_or_equal_to') }
    validates :price, presence: { message: I18n.t('view.live_studio/course.validates.price') }

    validates :teacher, presence: true
    validates :objective, presence: { message: I18n.t('view.live_studio/course.validates.objective') }, length: { in: 1..300 }, if: :objective_changed?
    validates :suit_crowd, presence: { message: I18n.t('view.live_studio/course.validates.suit_crowd') }, length: { in: 1..300 }, if: :suit_crowd_changed?

    belongs_to :teacher, class_name: '::Teacher'
    belongs_to :workstation

    has_many :events, -> { order('id asc') }
    has_many :lessons

    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: User

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::GroupPublicizeUploader

    scope :uncompleted, -> { where('live_studio_groups.status < ?', statuses[:completed]) }
    scope :for_sell, -> { where(status: [statuses[:teaching], statuses[:published]]) }


    def teacher_name
      teacher.try(:name)
    end

    def teachers
      [teacher].compact
    end

    def ready_lessons
      tmp_class_date = [start_at, events.map(&:class_date).min].min rescue start_at
      return if tmp_class_date.blank?
      return if tmp_class_date > Date.today
      teaching! if published?
      events.where(status: [-1, 0]).where('class_date <= ?', Date.today).map(&:ready!)
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

    after_create do
      teacher.increment!(:all_courses_count) if teacher
    end

    def lower_price
      sell_type.free? ? 0 : 1
    end
  end
end
