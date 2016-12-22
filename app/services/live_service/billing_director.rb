module LiveService
  class BillingDirector
    def initialize(lesson)
      @lesson = lesson
      @course = lesson.course
    end

    # 课程结算
    def billing
      # 结算金额
      money = total_money
      if @lesson.teacher.blank?
        @lesson.teacher = @course.teacher
        @lesson.save
      end

      billing = @lesson.billings.create(total_money: money, summary: "课程完成结算, 结算金额: #{money}")
      Payment::CashAccount.transaction do
        # 系统支出
        decrease_cash_admin_account(money, billing)
        # 服务费结账
        money -= service_fee_billing(money, billing)
        # 授课收入结账
        teach_fee_billing(money, billing)
        @lesson.close! && @lesson.finish! if @lesson.teaching?
        @lesson.complete!
      end
    end

    private

    def total_money
      @course.buy_tickets.where('got_lesson_ids like ?', "% #{@lesson.id}\n%").sum(:lesson_price)
    end

    def service_fee(money)
      service_money = LiveStudio::Course::SYSTEM_FEE * @lesson.live_count * @lesson.real_time
      [money, service_money].min
    end

    # 系统服务费账单
    def service_fee_billing(money, billing)
      system_money = service_money = service_fee(money)
      if @course.workstation
        sub_billing = billing.sub_billings.create(total_money: service_money, summary: "课程完成系统服务费结算, 结算金额: #{service_money}")
        system_money -= workstation_service_fee!(service_money, sub_billing)
      end
      system_service_fee!(system_money, sub_billing || billing)
      service_money
    end

    # 系统服务费代理商分成
    def workstation_service_fee!(service_money, billing)
      workstation_money = service_money * LiveStudio::Course::WORKSTATION_PERCENT
      workstation_money = service_money if workstation_money > service_money
      workstation_account = @course.workstation.cash_account!
      workstation_account.earning(workstation_money, @lesson, billing,
                                  "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得基础服务费分成: #{workstation_money}(#{LiveStudio::Course::WORKSTATION_PERCENT})")
      workstation_money
    end

    # 服务费系统收入
    def system_service_fee!(system_money, billing)
      increase_cash_admin_account(system_money, billing,
                                  "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得基础服务费分成: #{system_money}")
    end

    # 教课收入结账
    def teach_fee_billing(money, billing)
      sub_billing = billing.sub_billings.create(total_money: money, summary: "课程完成授课收入结算, 结算金额: #{money}") if @course.teacher_percentage < 100
      teacher_money = teacher_teach_fee!(money, sub_billing || billing)
      workstation_teach_fee!(money - teacher_money, sub_billing)
      money
    end

    # 教师授课收入
    def teacher_teach_fee!(money, billing)
      teacher_money = money
      teacher_money = teacher_money * @course.teacher_percentage.to_f / 100 if @course.teacher_percentage < 100
      teacher_account = @course.teacher.cash_account!
      teacher_account.earning(teacher_money, @lesson, billing,
                              "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得授课收入: #{teacher_money}")
      teacher_money
    end

    # 授课收入工作站分成
    def workstation_teach_fee!(money, billing)
      # 工作站不存在或者工作站金额小于等于0没有收入
      return 0 if money <= 0 || @course.workstation.blank?
      workstation_account = @course.workstation.cash_account!
      workstation_account.earning(money, @lesson, billing,
                                  "辅导班: #{@course.name} 的课程: #{@lesson.name} 结束. 获得授课收入: #{money}")
      money
    end

    # 结算完成后
    # 系统账户 支出结算金额
    def decrease_cash_admin_account(money, billing)
      CashAdmin.decrease_cash_account(money, billing, '课程完成 - 支出结算')
    end

    # 结算完成后
    # 系统账户 收取服务费
    def increase_cash_admin_account(money, billing, summary = nil)
      summary ||= '课程完成 - 系统服务费'
      CashAdmin.increase_cash_account(money, billing, summary)
    end
  end
end
