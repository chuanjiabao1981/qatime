module Registable
  extend ActiveSupport::Concern

  included do
    attr_accessor :register_code_value, :tmp_register_code
    attr_reader :register_columns_required, :skip_accept_required
    attr_accessor :accept

    validates_confirmation_of :email

    # 第一步注册验证
    validates :login_mobile, presence: true, length: { is: 11 }, numericality: { only_integer: true }, on: :create, unless: :is_guest
    validates :login_mobile, length: { is: 11 }, numericality: { only_integer: true }, if: :login_mobile_changed?, on: :update

    validates :password, length: { minimum: 6 }, if: :register_columns_required?

    # validates_presence_of :register_code_value, on: :create
    # validate :register_code_valid, on: :create
    validates :accept, acceptance: true, unless: :skip_accept_required?

    # 第二步注册更新验证
    validates_presence_of :avatar, :name, if: :register_columns_required?, on: :update, unless: :is_guest_was
    validates :email, allow_blank: true, format: { with: User::VALID_EMAIL_REGEX }, uniqueness: true, on: :update

    # 注册完成后更改注册码
    after_create :update_register_code
  end

  # 是否是注册必要信息
  def register_columns_required?
    @register_columns_required
  end

  # 手动强制调用验证注册信息
  def register_columns_required!
    @register_columns_required = true
    self
  end

  # 是否跳过accept验证
  def skip_accept_required?
    @skip_accept_required
  end

  # 强制跳过accept验证
  def skip_accept_required!
    @skip_accept_required = true
    self
  end

  private

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
