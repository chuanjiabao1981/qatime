class User < ActiveRecord::Base
  extend Enumerize

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ROLES = %w(admin guest manager teacher student waiter seller cash_admin)

  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :captcha
  attr_accessor :current_password
  attr_accessor :login_account
  attr_reader :captcha_required
  attr_reader :password_required
  attr_reader :teacher_or_student_columns_required
  # 支付密码
  attr_accessor :payment_captcha_required, :payment_captcha, :payment_password, :payment_password_required, :current_payment_password

  # 编辑上下文 用于条件验证
  attr_accessor :context

  has_secure_password

  validates :nick_name, allow_nil: true, allow_blank:true, uniqueness: true,
            format: {with: /\A[\p{Han}\p{Alnum}\-_]{3,10}\z/,message:"只可以是中文、英文或者下划线，最短3个字符最长10个字符，不可包含空格。"}

  validates :login_mobile, :email, uniqueness: true, allow_nil: true
  # 验证码验证
  validates :captcha, confirmation: { case_sensitive: false , message: '校验码不正确'}, if: :captcha_required?
  # 支付密码
  with_options if: :payment_captcha_required do
    validates :payment_captcha, confirmation: { case_sensitive: false }
    validates :payment_password, confirmation: true, length: { minimum: 6 }
  end
  with_options if: :payment_password_required do
    validates :payment_password, confirmation: true, length: { minimum: 6 }
  end

  # 个人安全信息修改
  validates :password, length: { minimum: 6, message: '最少输入6位（不支持特殊字符）' }, if: :password_required?, on: :update
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, if: :email_changed?, on: :update

  validates_presence_of :name, if: :teacher_or_student_columns_required?, on: :update
  validates_presence_of :avatar, message: '请上传头像', if: :teacher_or_student_columns_required?, on: :update

  validates_presence_of :name, :email, if: :not_teacher_or_student?, on: [:create, :update]
  # 邮箱必填
  # validates :email, presence: true, on: :update, if: ->(u) { u.name_was.nil? || u.email_was.present? }

  has_many :orders, class_name: ::Payment::Order
  has_many :topics, :dependent => :destroy,foreign_key: :author_id
  has_many :replies, :dependent => :destroy,foreign_key: :author_id
  has_many :faq_topics
  has_many :faqs
  has_many :messages
  has_many :user_devices
  has_one  :account, as: :accountable

  has_many :payment_recharges, class_name: Payment::Recharge # 通知记录
  has_many :payment_withdraws, class_name: Payment::Withdraw # 提现申请记录
  has_many :payment_refunds, class_name: Payment::Refund # 退款记录

  has_many :notifications, -> { order 'created_at desc'}, foreign_key: :receiver_id
  has_many :customized_course_action_notifications, -> { order 'created_at desc'}, foreign_key: :receiver_id
  has_many :course_action_notifications, class_name: '::LiveStudio::CourseActionNotification', foreign_key: :receiver_id

  has_one :cash_account, as: :owner, class_name: '::Payment::CashAccount'

  has_many :comments, foreign_key: :author_id

  has_many :wechat_users, class_name: Qawechat::WechatUser, :dependent => :destroy

  has_many :live_studio_play_records, class_name: LiveStudio::PlayRecord

  has_one :chat_account, class_name: '::Chat::Account'

  belongs_to :school

  belongs_to :province
  belongs_to :city

  has_many :login_tokens

  has_one :notification_setting, as: :owner

  GENDER_HASH = {
    male: 1, # 男
    female: 2 # 女
  }

  enumerize :gender, in: GENDER_HASH, i18n_scope: "enums.user.gender",
                      scope: true,
                      predicates: { prefix: true }
  # 用户是否设置了支付密码
  delegate :password?, to: :cash_account, prefix: true, allow_nil: true

  scope :by_city, ->(city_id) { where(city_id: city_id) }

  def unread_notifications_count
    self.notifications.unread.count
  end

  def self.find_by_login_account(login_account)
    VALID_EMAIL_REGEX =~ login_account ? find_by(email: login_account) : find_by(login_mobile: login_account)
  end

  def self.find_by_mobile_or_login_mobile(mobile)
    find_by(login_mobile: mobile) || find_by(mobile: mobile)
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def use_default_avatar
    default_avatar = Rails.public_path.join("imgs/avatar_#{self.role}.png")
    File.open(default_avatar) do |file|
      self.avatar = file
    end
    self
  end

  def use_default_avatar!
    use_default_avatar.save
  end

  def view_name
    return name unless teacher?
    return nick_name unless nick_name.nil? or nick_name.strip.empty?
    return "#{name[0]}老师"
  end

  ROLES.each do |method_name|
    define_method("#{method_name}?") do
      role == method_name
    end
  end

  def cash_account!
    return cash_account if cash_account.present?
    Payment::CashAccount.create(owner: self)
  end

  def require_captcha_confirmation?
    (name_was.present? && (email_changed? || mobile_changed? || parent_phone_changed?)) || new_record?
  end

  # 是否需要验证码，通过调用update_with_captcha来满足该条件
  def captcha_required?
    @captcha_required == true
  end

  def payment_pwd_captcha_required?
    @payment_pwd_captcha_required == true
  end

  # 手动强制调用验证码验证
  def captcha_required!
    @captcha_required = true
    self
  end

  # 验证是否更新密码
  def password_required?
    @password_required ==  true
  end

  # 手动强制验证密码
  def password_required!
    @password_required =  true
    self
  end

  # 使用密码更新数据，更新前验证当前密码
  def update_with_password(params, *options)
    current_password = params.delete(:current_password)
    result = if authenticate(current_password)
               update_attributes(params, *options)
             else
               assign_attributes(params, *options)
               valid?
               errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               false
             end
    self.password = self.password_confirmation = nil
    result
  end

  # 使用验证码更新数据
  def update_with_captcha(params, *options)
    @captcha_required = true
    update_attributes(params, *options)
  end

  # 更新支付密码
  def update_payment_pwd(params, *options)
    @payment_captcha_required = true
    if update(params, *options)
      cash_account!.update(password: payment_password, password_set_at: Time.now)
    end
  end

  # 使用旧支付密码重置
  def reset_payment_pwd(params)
    @payment_password_required = true
    assign_attributes(params)
    if valid?
      my_account = cash_account!
      current_payment_password = params.delete(:current_payment_password)
      if my_account.authenticate(current_payment_password)
        my_account.update(password: payment_password, password_set_at: Time.now)
      else
        errors.add(:current_payment_password, current_payment_password.blank? ? :blank : :invalid)
        false
      end
    end
  end

  def add_error_for_login_account
    errors.add(:login_account, :unregistered)
  end

  def login_account
    @login_account || login_mobile || email
  end

  def student_or_teacher?
    student? || teacher?
  end

  # 非老师和学生且并非找回密码
  def not_teacher_or_student?
    !student_or_teacher? && !password_required?
  end

  def male?
    gender == 'male'
  end

  def female?
    gender == 'female'
  end

  # 编辑资料
  def context_edit_profile?
    context == :edit_profile
  end

  def mobile
    login_mobile || super
  end

  private

  before_validation :convert_blank_field
  def convert_blank_field
    self.email = nil if email == ''
    self.login_mobile = nil if login_mobile == ''
  end

  # def register_code_valid
  #   # 这里虽然设置了true使得验证成功后此注册码过期，但是由于如果整体teacher不成成功会rollback，
  #   # 所以一个正确验证码在user其他字段不成功的情况下，同样还是有效的
  #   self.tmp_register_code = RegisterCode.verification(register_code_value, true)
  #   errors.add("register_code_value", "注册码不正确") unless tmp_register_code
  # end

  after_commit :sync_chat_account, on: :update, if: :chat_account_changed?
  def sync_chat_account
    Chat::SyncChatAccountJob.perform_later(id)
  end

  # chat account是否需要同步
  def chat_account_changed?
    return false unless chat_account
    return true unless chat_account.icon == avatar_url(:small)
    chat_account.name != (nick_name || name)
  end

  def captcha_effective?(expired_at)
    expired_at > Time.zone.now.to_i
  end

  # 学生或老师必填字段
  def teacher_or_student_columns_required?
    @teacher_or_student_columns_required == true
  end

  # 强制设置学生或老师必填字段
  def teacher_or_student_columns_required!
    @teacher_or_student_columns_required = true
  end
end
