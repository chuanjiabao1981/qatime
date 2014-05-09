class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, AvatarUploader



  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: true
  validates_presence_of :avatar,:name,:school
  validates :password, length: { minimum: 6 },:on => :create

  has_secure_password

  before_create :create_remember_token


  has_many :topics, :dependent => :destroy
  belongs_to :school

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    return true if self.role == "admin"
    false
  end
  def teacher?
    return true if self.role == "teacher"
    false
  end
  def student?
    return true if self.role == "student"
    false
  end
  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
