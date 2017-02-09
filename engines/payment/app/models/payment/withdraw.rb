module Payment
  class Withdraw < Transaction
    include AASM

    has_one :withdraw_record, foreign_key: 'payment_transaction_id', class_name: 'Payment::WithdrawRecord'
    has_one :weixin_transfer, as: :order

    enum status: %w(init allowed refused canceled paid)
    enum pay_type: %w(cash bank alipay wechat)

    attr_accessor :account_money_snap_shot, :payment_password, :ticket_token
    validate :validate_withdraw_amount, :validate_wechat, on: :create
    validate :check_password_or_token!, on: :create
    validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
    after_create :frozen_balance

    belongs_to :wechat_user, class_name: 'Qawechat::WechatUser'

    validates :wechat_user_id, presence: { message: '未绑定微信账户' }
    validates :wechat_user, presence: { message: '绑定账户不存在' }

    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    aasm column: :status, enum: true do
      state :init, initial: true
      state :allowed
      state :refused
      state :canceled
      state :paid

      event :allow, before: :allow_operator do
        transitions from: [:init], to: :allowed
      end

      event :refuse, before: :refuse_operator do
        transitions from: [:init], to: :refused
      end

      event :cancel, after: :cancel_frozen! do
        transitions from: [:init], to: :canceled
      end

      event :pay do
        transitions from: [:allowed], to: :paid
      end
    end

    def pay_and_ship!
      pay!
      cash_admin_billing!
    end

    def status_text(role=nil)
      role = role.present? && role == 'admin' ? 'admin' : 'teacher'
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

    private

    # 提现验证支付密码或者token
    def check_password_or_token!
      ticket_token.present? ? check_token! : check_password!
    end

    def check_token!
      errors.add('ticket_token', "无效的token") unless UserService::CashAccountManager.new(user).check_token(:withdraw, ticket_token)
    end

    def check_password!
      if payment_password.blank?
        errors.add(:payment_password, '支付密码不能为空')
      elsif cash_account.password_set_at.blank?
        errors.add(:payment_password, '还未设置支付密码')
      elsif cash_account.password_set_at > 24.hours.ago
        errors.add(:payment_password, '修改或者设置支付密码24小时内不可用')
      elsif !cash_account.authenticate(payment_password)
        errors.add(:payment_password, '支付密码不正确')
      end
    end

    def frozen_balance
      user.cash_account!.freeze_cash(amount)
    end

    after_create :instance_remote_order
    def instance_remote_order
      return if !wechat? || weixin_transfer
      WeixinTransfer.create(
        amount: amount,
        remote_ip: remote_ip,
        status: :unpaid,
        order_no: transaction_no,
        order: self
      )
    end

    def allow_operator(current_user)
      Payment::Withdraw.transaction do
        operator_record(status, 'allowed', current_user)
        withdraw_cash!
      end
    end

    def refuse_operator(current_user)
      operator_record(status, 'refused', current_user)
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
      wechat? && weixin_transfer.remote_transfer
    end

    # 取消冻结资金
    def cancel_frozen!
      user.cash_account!.freeze_cash(-amount)
    end

    def validate_withdraw_amount
      errors.add(:amount, "余额不足") unless cash_account.available_balance > amount.to_f
    end

    def validate_wechat
      self.errors.add(:pay_type, "微信未绑定，必须是本账户已绑定的微信号") if wechat? && user.wechat_users.blank?
    end

    def parse_raw_value_as_a_number(raw_value)
      Kernel.Float(raw_value) if raw_value !~ /\A0[xX]/
    rescue ArgumentError, TypeError
      nil
    end

    # 系统账户结算
    def cash_admin_billing!
      summary = "系统支付提现, 订单编号：#{transaction_no} 订单金额: #{amount}"
      billing = billings.create(total_money: amount, summary: summary)
      CashAdmin.decrease_cash_account(amount, billing, summary)
    end

    def cash_account
      @cash_account ||= user.cash_account! if user
    end
  end
end
