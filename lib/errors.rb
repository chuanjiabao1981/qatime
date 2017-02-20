module Payment
  BalanceNotEnough       = Class.new(StandardError) # 余额不足
  TokenInvalid           = Class.new(StandardError) # 无效的支付token
end
