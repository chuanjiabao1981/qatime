module Payment
  class Withdraw < Transaction

    enum status: %w(init allowed refused paid cancel)
    enum pay_type: %w(cash bank wechat alipay)

    attr_accessor :account_money_snap_shot
    validate :validate_withdraw_amount

    def status_text
      I18n.t("activerecord.status.withdraw.#{status}")
    end

    def pay_type_text
      I18n.t("enum.payment/withdraw.pay_type.#{pay_type}")
    end

    def change_money
      return self.value * -1
    end

    private
    def validate_withdraw_amount
      v = parse_raw_value_as_a_number(self.amount)
      if self.account_money_snap_shot.nil?
        self.account_money_snap_shot = self.user.account.money
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
