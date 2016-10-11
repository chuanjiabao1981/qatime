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
      billing = @lesson.billings.create(total_money: money, summary: "课程完成结算, 结算金额: #{money}")
      Payment::CashAccount.transaction do
        # 系统支出
        decrease_cash_admin_account(money, billing)
        # 每节课IM费用
        money -= im_fee!(money, billing)
        # 系统收取佣金
        money -= system_fee!(money, billing)
        # 教师分成
        money -= teacher_fee!(money, billing)
        # 代理商分成
        manager_fee!(money, billing)
        # 改变课程状态
        @lesson.close! && @lesson.finish! if @lesson.teaching?
        @lesson.complete!
        # 更新辅导课程完成数量
        @course.reset_completed_lesson_count!
      end
    end

    private

    def total_money
      @course.buy_tickets.sum(:lesson_price)
    end

    #IM聊天人头费
    def im_fee!(money, billing)
      im_money = LiveStudio::Course::IM_FEE * @lesson.live_count
      im_money = money if im_money > money
      increase_cash_admin_account(im_money, billing, :im_fee)
      im_money
    end

    # 系统服务费
    def system_fee!(money, billing)
      system_money = LiveStudio::Course::SYSTEM_FEE * @lesson.live_count * @lesson.real_time
      system_money = money if system_money > money
      increase_cash_admin_account(system_money, billing, :system_fee)
      system_money
    end

    # 教师分成
    def teacher_fee!(money, billing)
      teacher_money = money * @course.teacher_percentage.to_f / 100
      @lesson.teacher.cash_account!.earning(teacher_money, billing.target, billing, "课程完成 - #{@lesson.id} - #{@lesson.name} - #{teacher_money}/#{money}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money, billing)
      @course.workstation.cash_account!.earning(money, billing.target, billing, "课程完成 - #{@lesson.id} - #{@lesson.name}")
    end

    # 结算完成后
    # 系统账户 支出结算金额
    def decrease_cash_admin_account(money, billing)
      CashAdmin.decrease_cash_account(money, billing, '课程完成 - 支出结算')
    end

    # 结算完成后
    # 系统账户 收取服务费
    def increase_cash_admin_account(money, billing, msg = nil)
      case msg
      when :im_fee
        CashAdmin.increase_cash_account(money, billing, '课程完成 - IM聊天费')
      when :system_fee
        CashAdmin.increase_cash_account(money, billing, '课程完成 - 系统服务费')
      end
    end

    # 更新听课证
    def update_tickets
      ::LiveStudio::CourseTicketCleanerJob.perform_later(@lesson.id)
    end
  end
end
