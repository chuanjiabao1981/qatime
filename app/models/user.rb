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

  has_secure_password

  validates :nick_name, allow_nil: true, allow_blank:true, uniqueness: true,
            format: {with: /\A[\p{Han}\p{Alnum}\-_]{3,10}\z/,message:"只可以是中文、英文或者下划线，最短3个字符最长10个字符，不可包含空格。"}

  validates :login_mobile, uniqueness: true, allow_blank: true
  # 验证码验证
  validates :captcha, confirmation: { case_sensitive: false }, if: :captcha_required?

  # 个人安全信息修改
  validates :password, length: { minimum: 6 }, if: :password_required?, on: :update
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, if: :email_changed?, on: :update

  validates_presence_of :avatar, :name, if: :teacher_or_student_columns_required?, on: :update

  validates_presence_of :name, :email, if: :not_teacher_or_student?, on: [:create, :update]

  has_many :orders, class_name: ::Payment::Order
  has_many :topics, :dependent => :destroy,foreign_key: :author_id
  has_many :replies, :dependent => :destroy,foreign_key: :author_id
  has_many :faq_topics
  has_many :faqs
  has_many :messages
  has_one  :account, as: :accountable
  has_many :customized_course_action_notifications,->{ order 'created_at desc'},foreign_key: :receiver_id

  has_one :cash_account, as: :owner, class_name: '::Payment::CashAccount'

  has_many :comments,foreign_key: :author_id

  has_many :wechat_users, class_name: Qawechat::WechatUser, :dependent => :destroy

  has_many :live_studio_play_records, class_name: LiveStudio::PlayRecord

  has_one :chat_account, class_name: '::Chat::Account'

  belongs_to :school

  belongs_to :province
  belongs_to :city

  has_many :login_tokens

  GENDER_HASH = {
    male: 1, # 男
    female: 2 # 女
  }

  enumerize :gender, in: GENDER_HASH, i18n_scope: "enums.user.gender",
                      scope: true,
                      predicates: { prefix: true }

  def unread_notifications_count
    self.customized_course_action_notifications.unread.count
  end

  def self.find_by_login_account(login_account)
    return User.new if login_account.blank?
    user = VALID_EMAIL_REGEX =~ login_account ? find_by(email: login_account) : find_by(login_mobile: login_account)
    user || User.new
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
    errors.add(:login_account, :unregistered) if login_account.blank?
    errors.blank?
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

  private

  def register_code_valid
    # 这里虽然设置了true使得验证成功后此注册码过期，但是由于如果整体teacher不成成功会rollback，
    # 所以一个正确验证码在user其他字段不成功的情况下，同样还是有效的
    self.tmp_register_code = RegisterCode.verification(register_code_value, true)
    errors.add("register_code_value", "注册码不正确") unless tmp_register_code
  end

  after_commit :sync_chat_account, on: :update, if: :chat_account_changed?
  def sync_chat_account
    Chat::SyncChatAccountJob.perform_later(id)
  end

  # chat account是否需要同步
  def chat_account_changed?
    return false unless chat_account
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
