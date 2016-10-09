module Payment
  class ConsumptionRecord < ChangeRecord
    enumerize :change_type, in: { account: 0, alipay: 1, weixin: 2 }, default: :account
  end
end
