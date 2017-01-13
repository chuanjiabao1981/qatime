module LiveService
  class BillingDirector
    def initialize(lesson)
      @lesson = lesson
      @course = lesson.course
    end

    # 课程结算
    def billing
      check_lesson
      billing = @lesson.billings.create(total_money: total_money, summary: "课程完成结算, 结算金额: #{total_money}")
      Payment::CashAccount.transaction do
        # 系统支出
        decrease_cash_admin_account(total_money, billing)
        # 基础服务费
        increase_cash_admin_account(base_fee,
                                    billing,
                                    "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得基础服务费分成: #{base_fee}")
        # 代理商分成费用
        workstation_account.earning(workstation_percent_fee, @lesson, billing,
                                    "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得授课收入: #{workstation_percent_fee}")
        # 系统分成费用
        increase_cash_admin_account(system_percent_fee,
                                    billing,
                                    "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得基础服务费分成: #{system_percent_fee}")
        # 教师收入
        teacher_account.earning(teacher_money, @lesson, billing,
                                "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得授课收入: #{teacher_money}")
        # 服务费结账
        @lesson.complete!
      end
    end

    # 总金额
    def total_money
      @total_money ||= @lesson.ticket_items.billingable.includes(:ticket).map(&:ticket).sum(&:lesson_price).round(2)
    end

    # 基础服务费
    def base_fee
      return @base_fee if @base_fee.present?
      fee = LiveStudio::Course::SYSTEM_FEE * @lesson.ticket_items.billingable.count * @lesson.real_time / 100
      @base_fee = [total_money, fee].min.round(2)
    end

    # 分成费用
    def percent_fee
      @percent_fee ||= total_money - teacher_money
    end

    # 工作站收入
    def workstation_percent_fee
      @workstation_percent_fee ||= (percent_fee * 0.8).round(2)
    end

    # 系统分成
    def system_percent_fee
      @system_percent_fee ||= percent_fee - workstation_percent_fee
    end

    # 教师收入
    def teacher_money
      return @teacher_money if @teacher_money.present?
      money = (total_money - base_fee) * @course.teacher_percentage.to_f / 100
      @teacher_money = [money, total_money - base_fee].min.round(2)
    end

    private

    def workstation_account
      @workstation_account ||= @course.workstation.cash_account!
    end

    def teacher_account
      @teacher_account = @course.teacher.cash_account!
    end

    # 结算完成后
    # 系统账户 支出结算金额
    def decrease_cash_admin_account(money, billing)
      CashAdmin.decrease_cash_account(money, billing, '课程 #{@course.id}-#{@lesson.id}完成系统支出结算, 结算金额: #{money}')
    end

    # 结算完成后
    # 系统账户 收取服务费
    def increase_cash_admin_account(money, billing, summary = nil)
      summary ||= '课程完成 - 系统服务费'
      CashAdmin.increase_cash_account(money, billing, summary)
    end

    def check_lesson
      # 检查课程老师信息
      @lesson.teacher = @course.teacher unless @lesson.teacher.present?
      # 检查课程时长
      @lesson.real_time = @lesson.live_sessions.sum(:duration) unless @lesson.real_time.to_i > 0
      @lesson.save
    end
  end
end
