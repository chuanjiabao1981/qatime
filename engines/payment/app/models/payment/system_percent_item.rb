module Payment
  # 系统分成收入账单项
  class SystemPercentItem < BillingItem
    def summary
      "课程结束: 系统分成收入结算, 结算金额: #{amount}"
    end
  end
end
