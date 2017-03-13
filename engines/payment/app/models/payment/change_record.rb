module Payment
  # 账户流水
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    extend Enumerize
    enumerize :change_type, in: { account: 0, alipay: 1, weixin: 2 }, default: :account

    belongs_to :cash_account # 资金账户
    belongs_to :business, polymorphic: true # 关联交易
    belongs_to :target, polymorphic: true # 交易对象
    belongs_to :owner, polymorphic: true

    # 出账记录
    scope :out_changes, -> { where("payment_change_records.different < 0") }
    # 入账记录
    scope :in_changes, -> { where("payment_change_records.different > 0") }

    private

    before_create :copy_relation
    def copy_relation
      self.owner = cash_account.owner
      self.target ||= business.target if business.is_a?(Payment::Billing) || business.is_a?(Payment::BillingItem)
      self.target ||= business.product if business.is_a?(Payment::Order)
    end
  end
end
