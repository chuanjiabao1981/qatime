module Payment
  class BillingItem < ActiveRecord::Base
    belongs_to :billing
    belongs_to :owner, polymorphic: true
    belongs_to :cash_account

    belongs_to :parent, class_name: BillingItem
    has_many :items, class_name: BillingItem, foreign_key: "parent_id"

    protected

    # 系统支出
    def system_pay!(money, summary)
      CashAdmin.decrease_cash_account(money, billing, summary)
    end

    # 系统收入
    def system_income!(money, summary)
      CashAdmin.increase_cash_account(money, billing, summary)
    end

    # 账户收入
    def account_income!(account, money, summary)
      account.earning(money, billing.target, billing, summary)
    end

    # 创建以后执行转账
    after_create :account_transfer
    def account_transfer
      raise "请在子类实现该方法"
    end
  end
end
