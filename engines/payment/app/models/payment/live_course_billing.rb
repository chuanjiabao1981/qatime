module Payment
  class LiveCourseBilling < Billing
    # 计算总金额
    def calculate
      self.total_money = target.billing_amount
    end
  end
end
