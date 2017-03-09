module Payment
  # 系统分成收入账单项
  class SellPercentItem < BillingItem
    def summary
      "课程结束: 销售佣金结算, 结算金额: #{amount}"
    end
  end
end
