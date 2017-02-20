module Payment
  class LiveCourseTicketBilling < Billing
    belongs_to :ticket, polymorphic: true

    # 系统默认分成比例
    SYSTEM_PERCENT = 0.2
    # 教师默认分成比例
    TEACHER_DEFAULT_PERCENT = 80
    SELL_DEFAULT_PERCENT = 0.2

    SYSTEM_FEE_PRICE = 0.1 # 系统服务费设置0.1元

    # 计算总金额
    def calculate
      self.total_money = ticket.lesson_price
    end

    def billing
      # 支出总金额
      system_pay_item!
      # 系统服务费收入
      system_fee_item!
      # 分成账单
      percent_item!
      # 教师收入
      teacher_money_item!
    end

    def base_fee
      @base_fee ||= [SYSTEM_FEE_PRICE * duration_minutes, total_money].min
    end

    # 教师收入
    def teacher_money
      @teacher_money ||= teacher_percentage * (total_money - base_fee)
    end

    # 分成金额 代理商分成 + 系统分成
    def percent_money
      @percent_money ||= total_money - base_fee - teacher_money
    end

    # 系统分成收入
    def system_percent_money
      @system_percent_money ||= (percent_money * system_percentage).round(2)
    end

    # 经销商分成收入
    # 先按照分成比例计算，如果计算结果大于剩余金额使用剩余金额
    def sell_percent_money
      @sell_percent_money ||= [(percent_money * sell_percentage).round(2), percent_money - system_percent_money].min
    end

    # 发行商分成收入
    def workstation_percent_money
      @workstation_percent_money ||= percent_money - system_percent_money - sell_percent_money
    end

    private

    def system_pay_item!
      SystemPayItem.create!(billing: self,
                            cash_account: system_account,
                            owner: CashAdmin.current!,
                            amount: -total_money)
    end

    # 系统服务费
    def system_fee_item!
      SystemFeeItem.create!(billing: self,
                            cash_account: system_account,
                            owner: CashAdmin.current!,
                            amount: base_fee,
                            quantity: 1,
                            price: SYSTEM_FEE_PRICE,
                            duration: duration_minutes)
    end

    # 商家分成
    def percent_item!
      item = PercentItem.create!(billing: self,
                                 amount: percent_money,
                                 percent: 100 - (teacher_percentage * 100).to_i)

      # 系统分成收入
      system_percent_item!(item)
      # 分销商分成收入
      sell_percent_item!(item)
      # 工作站分成收入
      workstation_percent_item!(item)
    end

    def system_percent_item!(item)
      SystemPercentItem.create!(parent: item,
                                billing: self,
                                cash_account: system_account,
                                owner: CashAdmin.current!,
                                amount: system_percent_money,
                                percent: system_percentage * 100)
    end

    def sell_percent_item!(item)
      return if channel_seller.blank?
      SellPercentItem.create!(parent: item,
                              billing: self,
                              cash_account: sell_account,
                              owner: channel_seller,
                              amount: sell_percent_money,
                              percent:  sell_percentage * 100)
    end

    def workstation_percent_item!(item)
      WorkstationPercentItem.create!(parent: item,
                                     billing: self,
                                     cash_account: workstation_account,
                                     owner: workstation,
                                     amount: workstation_percent_money,
                                     percent: workstation_percentage * 100)
    end

    def teacher_money_item!
      TeacherMoneyItem.create(billing: self,
                              cash_account: teacher_account,
                              owner: target.teacher,
                              amount: teacher_money,
                              percent: (teacher_percentage * 100).to_i)
    end

    # 视频时长
    def duration_minutes
      @duration_minutes ||= (target.real_time.to_i / 60.0).round(2)
    end

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
    def workstation_percentage
      @workstation_percentage ||= 1 - SYSTEM_PERCENT - sell_percentage
    end

    # 教师分成比例
    def teacher_percentage
      @teacher_percent ||= target.course.teacher_percentage.to_f / 100
      # 非邀请辅导班教师分成比例使用默认分成比例
      @teacher_percent = TEACHER_DEFAULT_PERCENT.to_f / 100 if @teacher_percent >= 1
      @teacher_percent
    end

    # 经销商
    def channel_seller
      @channel_seller ||= ticket.channel_owner || workstation
    end

    # 经销商账户
    def sell_account
      @sell_account ||= channel_seller.try(:cash_account!)
    end

    # 发行商
    def workstation
      @workstation ||= target.course.workstation || Workstation.default
    end

    # 发行商资金账户
    def workstation_account
      workstation.cash_account!
    end

    # 教师资金账户
    def teacher_account
      target.teacher.cash_account!
    end

  end
end
