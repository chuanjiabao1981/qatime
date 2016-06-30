class CashAdmin < User

  def initialize(attributes = {})
    super(attributes)
    self.role = "cash_admin"
  end


  class << self
    # 系统现金账户
    def current
      cash_admin = find_by(role: 'cash_admin')
      if cash_admin.blank?
        cash_admin =
            create(
                name: 'cash_admin',
                email: 'cash_admin@qatime.cn',
                password: '123456',
                password_confirmation: '123456'
            )
      end
      cash_admin
    end

    # 系统账户余额
    def current_cash
      current.cash_account!.balance.to_f
    end

    # 系统账户支出
    def decrease_cash_account(money, ref, summary)
      current.cash_account!.decrease(money, ref, summary)
    end

    # 系统账户收入
    def increase_cash_account(money, ref, summary)
      current.cash_account!.increase(money, ref, summary)
    end
  end
end