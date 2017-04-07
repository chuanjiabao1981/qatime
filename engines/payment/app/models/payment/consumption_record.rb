module Payment
  class ConsumptionRecord < ChangeRecord
    enumerize :change_type, in: { account: 0, alipay: 1, weixin: 2 }, default: :account

    before_validation :copy_change_type, on: :create
    def copy_change_type
      self.change_type = business.pay_type if business.is_a?(Payment::Order)
    rescue StandardError => e
      p e
    end
  end
end
