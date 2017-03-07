module Payment
  # 账户流水
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    extend Enumerize
    enumerize :change_type, in: { account: 0, alipay: 1, weixin: 2 }, default: :account

    belongs_to :cash_account # 资金账户
    belongs_to :transaction, polymorphic: true # 关联交易
    belongs_to :target, polymorphic: true # 交易对象
    belongs_to :owner, polymorphic: true
  end
end
