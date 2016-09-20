module Payment
  # 账户流水
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    extend Enumerize
    enumerize :change_type, in: { account: 0, weixin: 1, alipay: 2 }, default: :account

    belongs_to :cash_account
    belongs_to :billing
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true

    private

    # 在创建记录以前矫正资金
    # 外部消费不影响账户余额
    before_create :correct_different
    def correct_different
      return if change_type.account?
      self.after = before
      self.different = 0
    end
  end
end
