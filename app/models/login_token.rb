class LoginToken < ApplicationRecord
  belongs_to :user

  enum client_type: {
    pc: 1,
    web: 2,
    app: 3
  }

  validates :user, presence: true
  validates :client_type, presence: true

  attr_accessor :remember_token
end
