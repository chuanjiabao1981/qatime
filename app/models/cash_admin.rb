class CashAdmin < User

  def initialize(attributes = {})
    super(attributes)
    self.role = "cash_admin"
  end


  class << self

    def current
      cash_admin = find_by(role: 'cash_admin')
      if cash_admin.blank?
        cash_admin =
            create(
                name: 'cash_admin',
                email: 'cash_admin@qatime.cn',
                password: '123456',
                password_confirmation: '123456',
            )
      end
      cash_admin
    end

    def decrease_cash_account(money, ref, summary)
      current.cash_account!.decrease(money, ref, summary)
    end

    def increase_cash_account(money, ref, summary)
      current.cash_account!.increase(money, ref, summary)
    end
  end
end