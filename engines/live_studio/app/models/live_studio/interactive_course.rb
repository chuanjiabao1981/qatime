module LiveStudio
  class InteractiveCourse < ActiveRecord::Base
    acts_as_taggable
    has_soft_delete

    include AASM
    extend Enumerize

    include Qatime::Stripable
    strip_field :name, :description

    include Qatime::Discussable

    require 'carrierwave/orm/activerecord'
    mount_uploader :publicize, ::PublicizeUploader

    enum status: {
      init: 0, # 初始化
      published: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3 # 已结束
    }
    enumerize :status, in: {
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
    belongs_to :province
    belongs_to :city
    belongs_to :author, class_name: '::User'

    has_many :interactive_lessons, -> { order(class_date: :asc) }
    has_many :teachers, through: :interactive_lessons
    has_many :buy_tickets, as: :product

    validates :name, presence: true, length: { in: 2..20 }
    validates :description, presence: true, length: { in: 5..300 }
    validates :grade, :subject, :workstation_id, presence: true
    validates :price, presence: true, numericality: { greater_than: :price_min, less_than_or_equal_to: 999_999 }
    validates :teacher_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :teacher_percentage_max }

    accepts_nested_attributes_for :interactive_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    validates_associated :interactive_lessons
    validate :interactive_lessons_uniq, on: :create

    scope :for_sell, -> { where(status: statuses[:published], buy_tickets_count: 0) }

    before_create do
      self.service_price = workstation.service_price if workstation
    end

    # 课程日期不能重复
    def interactive_lessons_uniq
      interactive_lessons.each do |lesson|
        lesson.errors.add(:class_date, I18n.t('view.live_studio/interactie_course.validate.class_date_uniq')) if interactive_lessons.find_all{ |x| x.class_date == lesson.class_date }.size > 1
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

    def order_params
      { amount: current_price, product: self }
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
      order.errors[:product] << '您已经购买过该课程' if buy_tickets.where(student_id: user.id).exists?
    end

    # 发货
    def deliver(order)
      ticket_price = left_lessons_count.zero? ? order.amount : order.amount.to_f / left_lessons_count
      ticket = buy_tickets.find_or_create_by(student_id: order.user_id, lesson_price: ticket_price,
                                             payment_order_id: order.id, buy_count: left_lessons_count)
      ticket.active!
    end

    def for_sell?
      published? && buy_tickets_count.zero?
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

    # 是否可以试听
    def can_taste?(user)
      return false unless user.student?
      return false if buy_tickets.where(student_id: user.id).exists?
      !taste_tickets.where(student_id: user.id).exists?
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
      [current_price.to_f - coupon.price, 0].max
    end

    def service_price
      (base_price.to_f * 60).to_i
    end

    def reset_left_price
      self.left_price = current_price
      save
    end

    def ready_lessons
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

    # 最低价格
    def price_min
      interactive_lessons.size.to_i * 9
    end
  end
end