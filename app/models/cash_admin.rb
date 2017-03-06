class CashAdmin < User
  def initialize(attributes = {})
    super(attributes)
    self.role = "cash_admin"
  end

  validate :unique_cash_admin, on: :create

  class << self
    # 系统现金账户
    def current!
      @current ||= first || create(
        name: '财务',
        email: 'cash_admin@qatime.cn',
        password: '123456',
        password_confirmation: '123456'
      )
    end

    # 系统账户余额
    def current_cash
      current!.cash_account!.balance.to_f
    end

    # 系统账户支出
    def decrease_cash_account(money, billing, summary)
      current!.cash_account!.consumption(money, billing.target, billing, summary)
    end

    # 系统账户收入
    def increase_cash_account(money, billing, summary)
      current!.cash_account!.earning(money, billing.target, billing, summary)
    end

    def cash_account!
      current!.cash_account!
    end
  end

  private

  def unique_cash_admin
    # 只能有一个cash_admin用户
    errors.add(:role, '现金账户已存在') if CashAdmin.first
  end
end
