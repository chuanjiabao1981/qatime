class CashAdmin < User
  scope :current, ->{ find_by(role: 'cash_admin') }

  def initialize(attributes = {})
    super(attributes)
    self.role = "cash_admin"
  end

  class << self
    def decrease_cash_account(money, ref, summary)
      current.cash_account.decrease(money, ref, summary)
    end

    def increase_cash_account(money, ref, summary)
      current.cash_account.increase(money, ref, summary)
    end
  end
end