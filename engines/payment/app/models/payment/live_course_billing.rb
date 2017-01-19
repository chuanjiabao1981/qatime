module Payment
  class LiveCourseBilling < Billing
    WORKSTATION_PERCENT = 0.8
    SYSTEM_FEE_PRICE = 0.1 # 系统服务费设置0.1元
    TEACHER_DEFAULT_PERCENT = 80

    # 计算账单
    def calculate
      calculate_total_money
      self
    end

    # 执行结账
    def billing
      calculate
      Payment::LiveCourseBilling.transaction do
        # 支出总金额
        system_pay_item!
        # 系统服务费收入
        system_fee_item!
        # 分成账单
        percent_item!
        # 教师收入
        teacher_money_item!
        save!
      end
    end

    # 基础服务费
    def base_fee
      @base_fee ||= [SYSTEM_FEE_PRICE * quantity * duration_minutes, total_money].min
    end

    # 教师收入
    def teacher_money
      @teacher_money ||= teacher_percent * (total_money - base_fee)
    end

    # 分成金额 代理商分成 + 系统分成
    def percent_money
      @percent_money ||= total_money - base_fee - teacher_money
    end

    # 工作站分成收入
    def workstation_percent_money
      @workstation_percent_money ||= (percent_money * WORKSTATION_PERCENT).round(2)
    end

    # 系统分成收入
    def system_percent_money
      @system_percent_money ||= percent_money - workstation_percent_money
    end

    private

    def system_account
      @system_account ||= CashAdmin.current!.cash_account!
    end

    def workstation_account
      workstation.cash_account!
    end

    def workstation
      @workstation ||= target.course.workstation || Workstation.default
    end

    def teacher_account
      target.teacher.cash_account!
    end

    # 总金额
    def calculate_total_money
      self.total_money = target.billing_amount
    end

    # 结算人数
    def quantity
      @quantity ||= target.ticket_items.billingable.count
    end

    def duration_minutes
      @duration_minutes ||= (target.real_time.to_i / 60.0).round(2)
    end

    def teacher_percent
      @teacher_percent ||= target.course.teacher_percentage.to_f / 100
      # 非邀请辅导班教师分成比例使用默认分成比例
      @teacher_percent = TEACHER_DEFAULT_PERCENT.to_f / 100 if @teacher_percent >= 1
      @teacher_percent
    end

    def system_pay_item!
      puts 'total_money: '
      puts total_money.to_f
      SystemPayItem.create!(billing: self,
                            cash_account: system_account,
                            owner: CashAdmin.current!,
                            amount: -total_money)
    end

    def system_fee_item!
      puts 'system_fee_item ----->>>'
      puts base_fee.to_f
      SystemFeeItem.create!(billing: self,
                            cash_account: system_account,
                            owner: CashAdmin.current!,
                            amount: base_fee,
                            quantity: quantity,
                            price: SYSTEM_FEE_PRICE,
                            duration: duration_minutes)
    end

    def percent_item!
      puts 'percent_item ----->>>'
      puts percent_money.to_f
      item = PercentItem.create!(billing: self,
                                 amount: percent_money,
                                 percent: 100 - (teacher_percent * 100).to_i)

      # 系统分成收入
      system_percent_item!(item)
      # 工作站分成收入
      workstation_percent_item!(item)
    end

    def system_percent_item!(item)
      puts 'system_percent_item ----->>>'
      puts system_percent_money.to_f
      SystemPercentItem.create!(parent: item,
                                billing: self,
                                cash_account: system_account,
                                owner: CashAdmin.current!,
                                amount: system_percent_money,
                                percent: 100 - WORKSTATION_PERCENT * 100)
    end

    def workstation_percent_item!(item)
      puts 'workstation_percent_money ----->>>'
      puts workstation_percent_money.to_f
      WorkstationPercentItem.create!(parent: item,
                                     billing: self,
                                     cash_account: workstation_account,
                                     owner: workstation,
                                     amount: workstation_percent_money,
                                     percent: WORKSTATION_PERCENT * 100)
    end

    def teacher_money_item!
      puts 'teacher_money_item ----->>>'
      puts teacher_money.to_f
      TeacherMoneyItem.create(billing: self,
                              cash_account: teacher_account,
                              owner: target.teacher,
                              amount: teacher_money,
                              percent: (teacher_percent * 100).to_i)
    end
  end
end
