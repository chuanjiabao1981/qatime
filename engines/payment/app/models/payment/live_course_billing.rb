module Payment
  class LiveCourseBilling < Billing
    has_one :sell_percent_item, foreign_key: 'billing_id'
    has_one :system_fee_item, foreign_key: 'billing_id'
    has_one :teacher_money_item, foreign_key: 'billing_id'
    has_one :platform_percent_item, foreign_key: 'billing_id'
    has_one :publish_percent_item, foreign_key: 'billing_id'

    def lesson_price
    end

    # 系统服务费
    def base_fee
      @base_fee ||= system_fee_item.amount.to_f
    end

    def base_price
      @base_price ||= system_fee_item.price.to_f
    end

    # 计算总金额
    def calculate
      self.total_money = target.billing_amount
    end

    # 系统服务费金额
    def system_money
      system_fee_item.amount.to_f
    end

    # 系统服务费价格
    def system_percentage
      system_fee_item.price.to_f
    end

    # 教师收入
    def teacher_money
      teacher_money_item.amount.to_f
    end

    def teacher_percentage
      teacher_money_item.percent.to_i
    end

    # 经销商分成收入
    def sell_money
      sell_percent_item.amount.to_f
    end

    # 销售经销商分成百分比
    def sell_percentage
      sell_percent_item.percent.to_i
    end

    # 平台分成收入
    def platform_money
      platform_percent_item.amount.to_f
    end

    # 平台分成百分比
    def platform_percentage
      platform_percent_item.percent.to_i
    end

    # 发行商分成收入
    def publish_money
      0
    end

    def publish_percentage
      0
    end
  end
end
