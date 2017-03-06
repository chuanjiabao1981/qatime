module Payment
  class LiveCourseTicketBilling < Billing
    belongs_to :ticket, polymorphic: true

    # 计算总金额
    def calculate
      self.total_money = ticket.lesson_price
    end

    # 系统服务费
    def base_fee
      @base_fee ||= [target.base_price * target.duration_minutes, total_money].min.round(2)
    end

    # 分成金额
    def percent_money
      @percent_money = total_money - base_fee
    end

    # 教师收入
    def teacher_money
      @teacher_money ||= (percent_money * teacher_proportion).round(2)
    end

    # 经销商分成收入
    def sell_seller_money
      @sell_seller_money ||= (percent_money * sell_seller_proportion).round(2)
    end

    # 跨区销售系统分成收入
    def sell_system_money
      @sell_system_money ||= (percent_money * sell_system_proportion).round(2)
    end

    # 发行商分成收入
    def publish_money
      @publish_money ||= (percent_money * publish_proportion).round(2)
    end

    # 系统分成收入
    # 其它角色分成后剩余金额，需要跟实际计算结果进行校验，差值过大不进行结账
    def system_money
      @system_money ||= percent_money - teacher_money - sell_seller_money - sell_system_money - publish_money
    end

    # 销售经销商分成百分比
    def sell_seller_percentage
      target.sell_percentage - sell_system_percentage
    end

    # 跨区销售分成百分比
    # 不能大于销售分成比例
    def sell_system_percentage
      [ticket.cross_region_percentage, target.sell_percentage].min
    end

    private

    # 教师分成比例
    def teacher_proportion
      target.teacher_percentage.to_f / 100
    end

    # 经销商分成比例
    def sell_seller_proportion
      sell_seller_percentage.to_f / 100
    end

    # 跨区销售系统分成比例
    def sell_system_proportion
      sell_system_percentage.to_f / 100
    end

    # 发行商分成比例
    def publish_proportion
      target.publish_percentage.to_f / 100
    end

    # 系统分成比例
    def system_proportion
      target.system_percentage.to_f / 100
    end

    # 总分成比例
    def total_proportion
      teacher_proportion + sell_seller_proportion + sell_system_proportion + publish_proportion + system_proportion
    end

    # 根据百分比计算得出系统收入
    def real_system_money
      (percent_money * system_proportion).round(2)
    end

    before_save :billing_check!
    def billing_check!
      calculate
      raise Payment::TotalPercentInvalid, "分成比例不正确" unless  1 == total_proportion
      raise Payment::SystemMoneyDifference, "系统分成金额差距过大" if (real_system_money - system_money).abs > 0.02
    end
  end
end
