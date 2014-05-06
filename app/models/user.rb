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
  has_many :replies, :dependent => :destroy

  belongs_to :school

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def is_teacher?
    if self.role == "teacher"
       true
    else
      false
    end
  end
  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
