class CashAdmin < User
  def initialize(attributes = {})
    super(attributes)
    self.role = "cash_admin"
  end

  validate :unique_cash_admin, on: :create

  class << self
    # 系统现金账户
    def current!
      first || create(
        name: 'cash_admin',
        email: 'cash_admin@qatime.cn',
        password: '123456',
        password_confirmation: '123456'
      )
    end

    # 系统账户余额
    def current_cash
      current.cash_account!.balance.to_f
    end

    # 系统账户支出
    def decrease_cash_account(money, billing, summary)
      current.cash_account!.decrease(money, billing, summary)
    end

    # 系统账户收入
    def increase_cash_account(money, billing, summary)
      current.cash_account!.increase(money, billing, summary)
    end
  end

  private

  def unique_cash_admin
    # 只能有一个cash_admin用户
    errors.add(:role, '现金账户已存在') if CashAdmin.first
  end
end
