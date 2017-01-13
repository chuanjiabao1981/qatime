module Payment
  # 系统分成收入账单项
  class SystemPercentItem < BillingItem
    protected

    def account_transfer
      system_income!(amount, "直播课程: 结算, 系统分成收入: #{amount}")
    end
  end
end
