class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :register_code_value,:tmp_register_code

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: true
  validates_presence_of :avatar,:name,:mobile ,if: :teacher_or_student?
  validates :mobile,length:{is: 11},if: :teacher_or_student?
  validates :mobile,numericality: { only_integer: true },if: :teacher_or_student?
  validates :school ,presence: true,if: :teacher?
  validates :password, length: { minimum: 6 },:on => :create
  validates :grade, inclusion: { in: APP_CONSTANT["grades_in_menu"]},if: :student?
  validates_presence_of :grade, if: :student?
  validates :nick_name,allow_nil: true,allow_blank:true,uniqueness: true,
            format: {with: /\A[\p{Han}\p{Alnum}\-_]{3,10}\z/,message:"只可以是中文、英文或者下划线，最短3个字符最长10个字符，不可包含空格。"}
  has_secure_password

  before_create :create_remember_token


  validates_presence_of :register_code_value, on: :create, if: :teacher_or_student?
  validate :register_code_valid, on: :create, if: :teacher_or_student?
  after_create :update_register_code


  has_many :topics, :dependent => :destroy,foreign_key: :author_id
  has_many :replies, :dependent => :destroy,foreign_key: :author_id
  has_many :faq_topics
  has_many :faqs
  has_many :messages
  has_one  :account
  has_many :action_notifications,->{ order 'created_at desc'},foreign_key: :receiver_id



  has_many :comments,foreign_key: :author_id

  belongs_to :school

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

  def admin?
    return true if self.role == "admin"
    false
  end
  def teacher_or_student?
    teacher? or student?
  end
  def teacher?
    return true if self.role == "teacher"
    false
  end
  def student?
    return true if self.role == "student"
    false
  end
  def manager?
    return true if self.role == "manager"
  end
  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
    def register_code_valid
      # 这里虽然设置了true使得验证成功后此注册码过期，但是由于如果整体teacher不成成功会rollback，
      # 所以一个正确验证码在user其他字段不成功的情况下，同样还是有效的
      self.tmp_register_code = RegisterCode.verification(self.register_code_value, true)
      if not self.tmp_register_code
        errors.add("register_code_value","注册码不正确")
      end
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
end
