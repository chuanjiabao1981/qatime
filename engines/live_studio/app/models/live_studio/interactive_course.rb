module LiveStudio
  class InteractiveCourse < ActiveRecord::Base
    serialize :subjects, Array

    acts_as_taggable
    has_soft_delete

    include AASM
    extend Enumerize

    include Qatime::Stripable
    strip_field :name, :description

    enum status: {
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3 # 已结束
    }

    aasm column: :status, enum: true do
      state :init, initial: true
      state :published
      state :teaching
      state :completed

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

    belongs_to :workstation

    has_many :interactive_lessons, -> { order(id: :asc) }
    has_many :teachers, through: :interactive_lessons

    validates :name, presence: true, length: { in: 2..20 }
    validates :description, presence: true, length: { in: 5..300 }
    validates :grade, presence: true
    validates :price, presence: true, numericality: { greater_than: :lower_price, less_than_or_equal_to: 999_999 }
    validates :teacher_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }

    accepts_nested_attributes_for :interactive_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    validates_associated :interactive_lessons

    has_many :qr_codes, as: :qr_codeable, class_name: "::QrCode"

    has_one :chat_team, class_name: '::Chat::Team', as: :teamable

    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: '::User'

    scope :for_sell, -> { where(status: statuses[:published]) }

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

    def order_params
      { amount: current_price, product: self }
    end

    # 剩余直播课程数量
    def left_lessons_count
      [interactive_lessons_count - finished_lessons_count, 0].max
    end

    # 发货
    def deliver(order)
    end

    def for_sell?
      published?
    end

    # 用户是否已经购买
    def own_by?(user)
      return false unless user.present?
      user.live_studio_tickets.map(&:course_id).include?(id)
    end

    # 已经购买
    def bought_by?(user)
      return false unless user.present?
      buy_tickets.where(student_id: user.id).exists?
    end

    # 试听结束
    def tasted?(user)
      return false unless user.present?
      taste_tickets.unavailable.where(student_id: user.id).exists?
    end

    # 正在试听
    def tasting?(user)
      return false unless user.present?
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
      return user.id == teacher_id if user.teacher?
      !user.student? && workstation_id == user.workstation_id
    end

    def lower_price
      lp = 0
      lp = interactive_lessons.size * 5 if interactive_lessons.size > 0
      lp
    end
  end
end
