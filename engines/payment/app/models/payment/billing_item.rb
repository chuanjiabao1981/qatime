module Payment
  # 账单项
  class BillingItem < ActiveRecord::Base
    belongs_to :billing
    belongs_to :owner, polymorphic: true
    belongs_to :cash_account

    belongs_to :parent, class_name: BillingItem
    has_many :items, class_name: BillingItem, foreign_key: "parent_id"

    # 账单摘要
    def summary
    end

    protected

    def system_account
      CashAdmin.cash_account!
    end

    # 系统支出
    def system_pay!
      Payment::CashManager.new(system_account).split_pay(amount, billing, self)
    end

    # 创建以后执行转账
    after_create :account_transfer
    def account_transfer
      Payment::CashAccount.transaction do
        # 系统账户支出
        system_pay!
        # 资金账户收入
        Payment::CashManager.new(cash_account).earning(amount, billing, self)
      end
    end
  end
end
