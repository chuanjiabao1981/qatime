module Payment
  # 系统服务费账单项
  class SystemFeeItem < BillingItem
    def summary
      "课程结束: 平台服务费结算, 结算金额: #{amount}"
    end
  end
end
