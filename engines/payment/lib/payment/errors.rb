module Payment
  BalanceNotEnough         = Class.new(StandardError) # 余额不足
  TokenInvalid             = Class.new(StandardError) # 无效的支付token

  TotalPercentInvalid      = Class.new(StandardError) # 分成比例不正确(总比例之和不是100%)
  SystemMoneyDifference    = Class.new(StandardError) # 系统分成比例不正确(按比例计算和剩余金额差值过大)
  InvalidOperation         = Class.new(StandardError) # 不允许的操作
  InvalidNotify            = Class.new(StandardError) # 无效通知
  DuplicateOrderError      = Class.new(StandardError) # 重复购买
end
