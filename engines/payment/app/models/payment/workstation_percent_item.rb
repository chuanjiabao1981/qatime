module Payment
  # 系统分成收入账单项
  class WorkstationPercentItem < BillingItem
    protected

    def account_transfer
      account_income!(cash_account, amount, "直播课程: 结算, 代理商分成收入: #{amount}")
    end
  end
end
