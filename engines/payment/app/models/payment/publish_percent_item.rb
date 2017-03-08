module Payment
  # 发行分成
  class PublishPercentItem < BillingItem
    def summary
      "课程结束: 发行分成收入结算, 结算金额: #{amount}"
    end
  end
end
