class User < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :avatar,:name
  has_many :topics, :dependent => :destroy
  has_many :replies, :dependent => :destroy

end