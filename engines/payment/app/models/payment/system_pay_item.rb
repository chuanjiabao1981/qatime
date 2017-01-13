module Payment
  # 系统服务费账单项
  class SystemPayItem < BillingItem

    protected

    def account_transfer
      system_pay!(amount, "直播课程: 结算, 系统支出费用: #{amount}")
    end
  end
end
