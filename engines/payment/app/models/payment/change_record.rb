module Payment
  # 账户流水
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    extend Enumerize
    enumerize :change_type, in: { account: 0, alipay: 1, weixin: 2 }, default: :account

    belongs_to :cash_account
    belongs_to :billing
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true

    validate :check_cash

    private

    # 在创建记录以前矫正资金
    # 外部消费不影响账户余额
    before_validation :correct_different, on: :create
    def correct_different
      return if change_type.account?
      self.after = before
      self.different = 0
    end

    def check_cash
      cash_account.available_balance if change_type.account?
    end
  end
end
