module Payment
  # 系统服务费账单项
  class SystemFeeItem < BillingItem
    protected

    def account_transfer
      system_income!(amount, "直播课程: 结算, 系统服务费收入: #{amount}")
    end
  end
end
