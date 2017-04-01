module Payment
  class Withdraw < Transaction
    include AASM

    has_one :withdraw_record, foreign_key: 'payment_transaction_id', class_name: 'Payment::WithdrawRecord'
    has_many :weixin_transfers, as: :order
    has_one :withdraw_remit, as: :target, class_name: 'Payment::WithdrawRemit'
    belongs_to :owner, polymorphic: true

    enum status: %w(init allowed refused canceled paid)
    enum pay_type: %w(cash bank alipay wechat station)

    attr_accessor :account_money_snap_shot, :captcha
    # 验证码验证
    validates :captcha, confirmation: { case_sensitive: false , message: I18n.t('error.payment/withdraw.captcha_confirm')}, on: :create, if: :captcha_required?
    validates :payee, presence: true, on: :create, if: Proc.new { |record| record.station? }
    validates :amount, presence: true, numericality: { greater_than: 0 }, on: :create, if: Proc.new { |record| record.station? }
    validate :amount_balance_valid, on: :create, if: Proc.new { |record| record.station? }

    validate :validate_withdraw_amount, :validate_wechat, on: :create, unless: Proc.new { |record| record.station? }

    after_create :decrease_cash!

    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    scope :is_close, -> { where(close: true) }
    scope :not_close, -> { where(close: false) }

    aasm column: :status, enum: true do
      state :init, initial: true
      state :allowed
      state :refused
      state :canceled
      state :paid

      event :allow do
        transitions from: [:init], to: :allowed
      end

      event :refuse, before: :refund_cash! do
        transitions from: [:init], to: :refused
      end

      event :cancel, after: :refund_cash! do
        transitions from: [:init], to: :canceled
      end

      event :pay do
        transitions from: [:allowed], to: :paid
      end
    end

    # 是否需要验证码
    def captcha_required?
      @captcha_required == true
    end

    # 手动强制调用验证码验证
    def captcha_required!
      @captcha_required = true
      self
    end

    def can_close?
      %w[refused canceled paid].include?(status)
    end

    def status_text(role=nil)
      role = case role.to_s
               when 'admin' then 'admin'
               when 'station' then 'station'
               else
                 'teacher'
             end
      I18n.t("activerecord.status.withdraw.#{role}.#{status}")
    end

    def pay_type_text
      I18n.t("enum.payment/withdraw.pay_type.#{pay_type}") + " #{cash? || wechat? ? nil : "(#{withdraw_record.account} #{withdraw_record.name})"}"
    end

    def change_money
      return self.value * -1
    end

    def self.i18n_options_statuses
      statuses.slice(:allowed,:refused).map{|k,_| [I18n.t("activerecord.status.withdraw.admin.#{k}"), k]}
    end

    def account_owner
      owner || user
    end

    private

    # 创建提现记录以后直接扣除账户余额
    def decrease_cash!
      # AccountService::CashManager.new(user.cash_account!).decrease('Payment::WithdrawChangeRecord', amount, self)
      AccountService::CashManager.new(account_owner.cash_account!).decrease('Payment::WithdrawChangeRecord', amount, self)
      AccountService::CashManager.new(account_owner.available_account).decrease('Payment::WithdrawChangeRecord', amount, self) if account_owner.is_a?(Workstation)
    end

    # 提现失败以后返还账户余额
    def refund_cash!
      # AccountService::CashManager.new(user.cash_account!).increase('Payment::WithdrawRefundRecord', amount, self)
      AccountService::CashManager.new(account_owner.cash_account!).increase('Payment::WithdrawRefundRecord', amount, self)
      AccountService::CashManager.new(account_owner.available_account).increase('Payment::WithdrawRefundRecord', amount, self) if account_owner.is_a?(Workstation)
    end

    def allow_operator(current_user)
      Payment::Withdraw.transaction do
        operator_record(status,'allowed',current_user)
        withdraw_cash!
      end
    end

    def refuse_operator(current_user)
      operator_record(status,'refused',current_user)
      cancel_frozen!
    end

    # 操作记录
    def operator_record(from, to, current_user)
      Payment::WithdrawActionRecord.create(
        actionable: self,
        operator: current_user,
        from: from,
        to: to,
        event: "withdraw",
        name: "withdraw"
      )
    end

    # 变动用户余额
    def withdraw_cash!
      user.cash_account!.withdraw(amount, self)
      # 提现类型是微信时 创建自动转账数据
      wechat? && weixin_transfers.create(
        amount: amount,
        remote_ip: remote_ip,
        status: :unpaid,
        order_no: transaction_no
      )
    end

    def validate_withdraw_amount
      v = parse_raw_value_as_a_number(self.amount)
      if self.account_money_snap_shot.nil?
        self.account_money_snap_shot = self.user.cash_account!.balance
      end
      if v
        if v > 0
          if self.account_money_snap_shot < v
            self.errors.add(:value,"账户资金不足，无法提取!")
          end
        else
          self.errors.add(:value,"请输大于0的数字")
        end
      else
        self.errors.add(:value,"请输入数字")
      end
    end

    # 余额校验
    def amount_balance_valid
      if self.owner.cash_account.balance.to_f < self.amount.to_f
        errors.add(:amount, I18n.t("error.payment/withdraw.amount_overflow"))
      end
    end

    def validate_wechat
      self.errors.add(:pay_type, "微信未绑定，必须是本账户已绑定的微信号") if wechat? && user.wechat_users.blank?
    end

    def parse_raw_value_as_a_number(raw_value)
      Kernel.Float(raw_value) if raw_value !~ /\A0[xX]/
    rescue ArgumentError, TypeError
      nil
    end
  end
end
