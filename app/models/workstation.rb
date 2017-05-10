# 工作站
class Workstation < ActiveRecord::Base
  include AASM
  extend Enumerize

  # stop: 未运营 running: 运营中
  enum status: { stopping: 0, running: 1 }
  enumerize :status, in: { stopping: 0, running: 1 }

  aasm column: :status, enum: true do
    state :running, initial: true
    state :stopping

    event :run do
      transitions from: :stopping, to: :running
    end

    event :stop do
      transitions from: :running, to: :stopping
    end
  end

  belongs_to :manager, class_name: "Manager"

  has_one :cash_account, -> { where type: 'Payment::CashAccount' },  as: :owner, class_name: '::Payment::CashAccount'
  has_one :available_account, as: :owner, class_name: '::Payment::AvailableAccount'
  has_many :withdraws, as: :owner, class_name: '::Payment::Withdraw'
  belongs_to :city, counter_cache: true
  has_one  :account, as: :accountable
  has_many :customized_courses
  scope :by_manager_id, ->(t) { where(manager_id: t) if t }

  has_many :live_studio_courses, class_name: LiveStudio::Course
  has_many :live_studio_interactive_courses, class_name: LiveStudio::InteractiveCourse
  has_many :live_studio_video_courses, class_name: LiveStudio::VideoCourse

  # 我的经销记录
  has_many :sell_live_studio_tickets, as: :seller, class_name: LiveStudio::BuyTicket
  # 经销的直播课
  has_many :sell_live_studio_courses, -> { distinct }, through: :sell_live_studio_tickets, source: :product, source_type: LiveStudio::Course
  # 我经销的一对一
  has_many :sell_live_studio_interactive_courses, -> { distinct }, through: :sell_live_studio_tickets, source: :product, source_type: LiveStudio::InteractiveCourse
  # 我经销的视频课
  has_many :sell_live_studio_video_courses, -> { distinct }, through: :sell_live_studio_tickets, source: :product, source_type: LiveStudio::VideoCourse

  has_many :waiters
  has_many :sellers
  has_many :teachers

  has_many :invitations, as: :target
  has_many :course_requests, class_name: LiveStudio::CourseRequest # 招生请求，用于审核

  has_many :action_records
  # 优惠码
  has_one :coupon, as: :owner, class_name: "::Payment::Coupon"
  # 经销商推广二维码课程
  has_many :qr_codes, as: :qr_codeable
  # 经销订单
  has_many :orders, as: :seller, class_name: "::Payment::Order"
  # 退款订单
  has_many :refunds, as: :seller, class_name: "::Payment::Refund"

  has_many :sale_tasks, as: :target, class_name: '::Payment::SaleTask'

  validates_length_of :name, maximum: 20, minimum: 2
  validates_presence_of :name, :manager, :city, :join_price, :caution_money, :contract_start_date_at, :contract_end_date_at
  validates :platform_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :service_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate do |record|
    if record.contract_start_date_at.try(:to_date) && record.contract_end_date_at.try(:to_date)
      errors.add(:contract_end_date_at, I18n.t("error.workstation.contract_end_date_at")) if record.contract_start_date_at >= record.contract_end_date_at
    end
  end

  accepts_nested_attributes_for :coupon, allow_destroy: true, reject_if: proc { |attributes| attributes['code'].blank? }

  before_update :clean_city_default, if: :clean_city_default_required?
  after_commit :set_default_of_city, if: :set_default_of_city_required?

  # 更新city默认工作站
  def set_default_of_city
    city.update(workstation_id: self.id)
  end

  # 修改工作站 清空旧城市默认值
  def clean_city_default
    old_city = City.find_by(id: city_id_was)
    old_city.update(workstation_id: nil) if old_city
  end

  def set_default_of_city_required?
    @set_default_of_city_required == true
  end

  def set_default_of_city_required!
    @set_default_of_city_required = true
    self
  end

  def clean_city_default_required?
    @clean_city_default_required == true
  end

  def clean_city_default_required!
    @clean_city_default_required = true
    self
  end

  def is_default_of_city
    city && city.workstation_id == id
  end

  def cash_account!
    cash_account || ::Payment::CashAccount.create(owner: self, type: "Payment::CashAccount")
  end

  # 不可用于提现的收入额
  # options (assess_billing, business_klass)
  def percent_item_amount(options = {})
    options[:assess_billing] ||= false

    results = cash_account.earning_records
    results = results.business_by_klass(options[:business_klass]) if options[:business_klass].present?


    if options[:assess_billing]
      results = results.assess_billing
    else
      results = results.not_assess_billing
    end
    results.sum(:amount)
  end

  def city_name
    city.try(:name)
  end

  def self.default
    @workstation ||= Workstation.find_by(email: 'admin@qatime.cn')
    if @workstation.nil?
      m = Manager.find_by(email: 'admin@qatime.cn')
      @workstation = Workstation.find_or_create_by(email: 'admin@qatime.cn', name: '默认工作站', manager: m)
    end
    @workstation
  end

  private

  after_create :init_cash
  def init_cash
    cash_account ||= ::Payment::CashAccount.create(owner: self, type: "Payment::CashAccount")
    if caution_money.to_f > 0
      AccountService::CashManager.new(cash_account).increase('Payment::DepositRecord', caution_money, self)
      cash_account.deposit_balance = caution_money
      cash_account.save
    end
    ::Payment::AvailableAccount.create(owner: self)
  end

  before_validation :default_video_service_price, on: :create
  def default_video_service_price
    self.video_service_price ||= 5
  end
end
