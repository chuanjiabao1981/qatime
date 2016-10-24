module Payment
  class Withdraw < Transaction
    include AASM

    has_one :withdraw_record, foreign_key: 'payment_transaction_id', class_name: 'Payment::WithdrawRecord'

    enum status: %w(init allowed refused canceled)
    enum pay_type: %w(cash bank alipay)

    attr_accessor :account_money_snap_shot
    validate :validate_withdraw_amount, on: :create
    after_create :frozen_balance

    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    aasm column: :status, enum: true do
      state :init, initial: true
      state :allowed
      state :refused
      state :canceled

      event :allow, before: :allow_operator do
        transitions from: [:init], to: :allowed
      end

      event :refuse, before: :refuse_operator do
        transitions from: [:init], to: :refused
      end

      event :cancel, after: :cancel_frozen! do
        transitions from: [:init], to: :canceled
      end
    end

    def status_text(role=nil)
      role = role.present? && role == 'admin' ? 'admin' : 'teacher'
      I18n.t("activerecord.status.withdraw.#{role}.#{status}")
    end

    def pay_type_text
      I18n.t("enum.payment/withdraw.pay_type.#{pay_type}") + " #{cash? ? nil : "(#{withdraw_record.account} #{withdraw_record.name})"}"
    end

    def change_money
      return self.value * -1
    end

    def self.i18n_options_statuses
      statuses.slice(:allowed,:refused).map{|k,_| [I18n.t("activerecord.status.withdraw.admin.#{k}"), k]}
    end

    private
    def frozen_balance
      user.cash_account!.frozen(amount)
    end

    def allow_operator(current_user)
      operator_record(status,'allowed',current_user)
      withdraw_cash!
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

    # 变动余额
    def withdraw_cash!
      user.cash_account!.withdraw(amount, self)
    end

    # 取消冻结资金
    def cancel_frozen!
      user.cash_account!.cancel_frozen(amount)
    end

    def validate_withdraw_amount
      v = parse_raw_value_as_a_number(self.amount)
      if self.account_money_snap_shot.nil?
        self.account_money_snap_shot = self.user.cash_account.balance
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

    def parse_raw_value_as_a_number(raw_value)
      Kernel.Float(raw_value) if raw_value !~ /\A0[xX]/
    rescue ArgumentError, TypeError
      nil
    end
  end
end
