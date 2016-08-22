class User < ActiveRecord::Base
  extend Enumerize

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ROLES = %w(admin guest manager teacher student waiter seller cash_admin)

  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :register_code_value, :tmp_register_code
  attr_accessor :captcha
  attr_accessor :current_password
  attr_accessor :login_account
  attr_reader :captcha_required
  attr_reader :password_required
  attr_reader :update_register_required

  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: true
  # validates_presence_of :avatar,:name,:mobile ,if: :teacher_or_student?

  validates_confirmation_of :email, :parent_phone
  validates_presence_of :avatar, :name, if: :student_or_teacher_register_update_need?, on: :update
  validates_presence_of :grade, if: :student_register_update_need?, on: :update
  validates_presence_of :subject, :category, if: :teacher_register_update_need?, on: :update
  validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, if: :register_teacher_or_student?
  validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, on: :update
  validates :email_confirmation, presence: true, if: :register_teacher_or_student_change_email?, on: [:update]
  validates :parent_phone, allow_blank: true, length: { is: 11 }, numericality: { only_integer: true }, on: :update
  validates :parent_phone_confirmation, presence: true, if: :register_teacher_or_student_change_parent_phone?, on: :update

  validates :login_mobile, length: { is: 11 }, uniqueness: true, numericality: { only_integer: true }, if: :teacher_or_student?, on: :create
  validates :login_mobile, allow_blank: true, length: { is: 11 }, uniqueness: true, numericality: { only_integer: true }, if: :student_or_teacher_register_update_need?, on: :update

  # validates :mobile,length:{is: 11},if: :teacher_or_student?
  # validates :mobile,numericality: { only_integer: true },if: :teacher_or_student?

  # validates :school ,presence: true,if: :teacher?
  validates :password, length: { minimum: 6 }, if: :update_password?
  # validates :grade, inclusion: { in: APP_CONSTANT["grades_in_menu"]},if: :student?
  # validates_presence_of :grade, if: :student?
  validates :nick_name, allow_nil: true, allow_blank:true, uniqueness: true,
            format: {with: /\A[\p{Han}\p{Alnum}\-_]{3,10}\z/,message:"只可以是中文、英文或者下划线，最短3个字符最长10个字符，不可包含空格。"}

  # 验证码验证
  validates :captcha, confirmation: { case_sensitive: false }, if: :captcha_required?
  validates :captcha_confirmation, presence: true, length: { minimum: 4 }, if: :captcha_required?

  has_secure_password

  has_many :orders, class_name: ::Payment::Order

  validates_presence_of :register_code_value, on: :create, if: :teacher_or_student?
  validate :register_code_valid, on: :create, if: :teacher_or_student?

  after_create :update_register_code, on: :update, if: :register_teacher_or_student?

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

  def teacher_or_student?
    teacher? or student?
  end

  # 是否完善注册第二步个人信息
  # 使用姓名是否存在判断需要验证注册第二步个人信息字段
  def register_teacher_or_student?
    (teacher? || student?) && !name_was.present?
  end

  # 验证注册第二步验证邮箱的确认输入
  def register_teacher_or_student_change_email?
    register_teacher_or_student? && email?
  end

  # 验证注册第二步验证家长手机的确认输入
  def register_teacher_or_student_change_parent_phone?
    register_teacher_or_student? && parent_phone?
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

  # 是否需要密码
  def password_required?
    @password_required == true
  end

  # 手动强制调用验证码验证
  def password_required!
    @password_required = true
    self
  end

  # 是否需要验证是否完善个人信息
  def update_register_required?
    @update_register_required ==  true
  end

  # 手动强制调用验证完善个人信息
  def update_register_required!
    @update_register_required = true
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

  def login_mobile_or_mobile
    login_mobile || mobile
  end

  def login_account
    login_mobile || email
  end

  private

  def register_code_valid
    # 这里虽然设置了true使得验证成功后此注册码过期，但是由于如果整体teacher不成成功会rollback，
    # 所以一个正确验证码在user其他字段不成功的情况下，同样还是有效的
    self.tmp_register_code = RegisterCode.verification(register_code_value, true)
    errors.add("register_code_value", "注册码不正确") unless tmp_register_code
  end

  def update_register_code
    if self.tmp_register_code
      self.tmp_register_code.user = self
      self.tmp_register_code.save
      if self.student?
        self.school_id = self.tmp_register_code.school_id
        self.save
      end
    end
  end

  after_commit :sync_chat_account, on: :update, if: :chat_account_changed?
  def sync_chat_account
    Chat::SyncChatAccountJob.perform_later(id)
  end

  # chat account是否需要同步
  def chat_account_changed?
    return false unless chat_account
    name_changed? || nick_name_changed? || avatar_changed?
  end

  def captcha_effective?(expired_at)
    expired_at > Time.zone.now.to_i
  end

  # 是否验证密码
  def update_password?
    !password.nil? || password_required?
  end

  # 是否需要验证学生或老师注册第二步的共有字段
  # 1.当注册后，未完善个人信息，找回密码时，不需要验证(姓名，头像)
  # 2.当admin或者manager修改安全信息时，不需要验证(姓名，头像)
  def student_or_teacher_register_update_need?
    teacher_or_student? && !update_password? && @update_register_required == true
  end

  # 是否需要验证学生注册第二步的特有字段
  # 1.当注册后，未完善个人信息，找回密码时，不需要验证(年级)
  # 2.当admin或者manager修改安全信息时，不需要验证(年级)
  def student_register_update_need?
    student? && !update_password? && @update_register_required == true
  end

  # 是否需要验证教师注册第二步的特有字段
  # 1.当注册后，未完善个人信息，找回密码时，不需要验证(科目)
  # 2.当admin或者manager修改安全信息时，不需要验证(科目)
  def teacher_register_update_need?
    teacher? && !update_password? && @update_register_required == true
  end
end
