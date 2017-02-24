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
    def sell_money
      @sell_money ||= (percent_money * sell_proportion).round(2)
    end

    # 发行商分成收入
    def publish_money
      @publish_money ||= (percent_money * publish_proportion).round(2)
    end

    # 系统分成收入
    # 其它角色分成后剩余金额，需要跟实际计算结果进行校验，差值过大不进行结账
    def system_money
      @system_money ||= percent_money - teacher_money - sell_money - publish_money
    end

    private

    # 系统分成比例
    def system_percentage
      SYSTEM_PERCENT
    end

    # 分销商分成比例
    def sell_percentage
      # 如果没有经销商使用默认经销商分成比例
      return SELL_DEFAULT_PERCENT if ticket.sell_channel.blank?
      @sell_percentage ||= [ticket.sell_channel.percentage.to_f / 100.0, 1 - SYSTEM_PERCENT].min
    end

    # 发行商分成比例
    def publish_percentage
      @publish_percentage ||= 1 - SYSTEM_PERCENT - sell_percentage
    end

    # 经销商
    def channel_seller
      @channel_seller ||= ticket.channel_owner || workstation
    end

    # 经销商
    def seller
      @seller ||= ticket.seller || Workstation.default
    end

    # 经销商账户
    def sell_account
      @sell_account ||= seller.cash_account!
    end

    # 发行商
    def workstation
      @workstation ||= target.workstation || Workstation.default
    end

    # 发行商资金账户
    def publish_account
      workstation.cash_account!
    end

    # 教师资金账户
    def teacher_account
      target.teacher.cash_account!
    end

    # 教师分成比例
    def teacher_proportion
      target.teacher_percentage.to_f / 100
    end

    # 经销商分成比例
    def sell_proportion
      target.sell_percentage.to_f / 100
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
      teacher_proportion + sell_proportion + publish_proportion + system_proportion
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
