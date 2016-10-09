module Payment
  class Withdraw < Transaction
    has_one :withdraw_record, foreign_key: 'payment_transaction_id', class_name: 'Payment::WithdrawRecord'

    enum status: %w(init allowed refused cancel)
    enum pay_type: %w(cash bank alipay)

    attr_accessor :account_money_snap_shot
    validate :validate_withdraw_amount, on: :create

    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    def status_text(role=nil)
      role = role.present? && role == 'admin' ? 'admin' : 'teacher'
      I18n.t("activerecord.status.withdraw.#{role}.#{status}")
    end

    def pay_type_text
      I18n.t("enum.payment/withdraw.pay_type.#{pay_type}")
    end

    def change_money
      return self.value * -1
    end

    def self.i18n_options_statuses
      statuses.slice(:allowed,:refused).map{|k,_| [I18n.t("activerecord.status.withdraw.admin.#{k}"), k]}
    end

    # 通过审核
    def allow
      allowed!
      user.cash_account.update(balance: user.cash_account.balance - amount)
    end

    private
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
