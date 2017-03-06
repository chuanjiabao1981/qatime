module Payment
  # 跨区销售系统分成收入账单项
  class CrossRegionPercentItem < BillingItem
    def summary
      "课程结束: 跨区销售分成收入结算, 结算金额: #{amount}"
    end
  end
end
