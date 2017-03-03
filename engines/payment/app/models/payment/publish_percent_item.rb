module Payment
  # 发行分成
  class PublishPercentItem < BillingItem
    protected

    def account_transfer
      account_income!(cash_account, amount, "直播课程: 结算, 发行商分成收入: #{amount}")
    end
  end
end
