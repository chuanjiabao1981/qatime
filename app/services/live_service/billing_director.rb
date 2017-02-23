module LiveService
  class BillingDirector
    def initialize(lesson)
      @lesson = lesson
      @course = lesson.course
    end

    # 课程结算
    def billing
      return unless check_lesson
      # 课程总账单
      billing = Payment::LiveCourseBilling.create(target: @lesson, from_user: @lesson.teacher)

      # 针对每一个购买记录单独结账
      @lesson.ticket_items.billingable.includes(ticket: [:channel_owner, :sell_channel]).each do |item|
        billing_ticket(billing, item)
      end
      # 所有的购买记录都结账完成以后课程结账完成
      @lesson.complete! if @lesson.ticket_items.billingable.blank?
    rescue StandardError => e
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "辅导班结账失败-#{@lesson.id}")
    end

    # 购买记录单独结账
    # billing： 父账单
    def billing_ticket(billing, ticket_item)
      ticket_item.with_lock do
        ticket = ticket_item.ticket
        item_billing = Payment::LiveCourseTicketBilling.create!(target: @lesson, from_user: @lesson.teacher, parent: billing, ticket: ticket)
        # 系统支出
        system_pay_item!(item_billing)
        # 系统服务费收入
        system_fee_item!(item_billing)
        # 教师收入
        teacher_money_item!(item_billing, @lesson.teacher)
        # 经销商收入
        sell_money_item!(item_billing, ticket.seller)
        # 发行商收入
        publish_money_item!(item_billing, @course.workstation)
        # 系统分成收入
        system_money_item!(item_billing)
        ticket_item.settled!
        # 这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
        yield if block_given?
      end
    end

    private

    # 检查课程是否可以结账
    def check_lesson
      # 检查课程老师信息
      @lesson.teacher = @course.teacher unless @lesson.teacher.present?
      # 结账前确保教师有资金账户
      @lesson.teacher.cash_account!
      # 检查课程时长
      @lesson.real_time = @lesson.live_sessions.sum(:duration) unless @lesson.real_time.to_i > 0
      @lesson.save
      @lesson.finished? || @lesson.billing?
    end

    # 系统账户
    def system_account
      @system_account ||= CashAdmin.current!.cash_account!
    end

    # 系统支出
    def system_pay_item!(billing)
      Payment::SystemPayItem.create!(billing: billing,
                                     cash_account: system_account,
                                     owner: CashAdmin.current!,
                                     amount: billing.total_money)
    end

    # 系统服务费
    def system_fee_item!(billing)
      Payment::SystemFeeItem.create!(billing: billing,
                                     cash_account: system_account,
                                     owner: CashAdmin.current!,
                                     amount: billing.base_fee,
                                     quantity: 1,
                                     price: @lesson.base_price,
                                     duration: @lesson.duration_minutes)
    end

    # 系统分成收入
    def system_money_item!(billing)
      Payment::SystemPercentItem.create!(billing: billing,
                                         cash_account: system_account,
                                         owner: CashAdmin.current!,
                                         amount: billing.system_money,
                                         percent: @lesson.system_percentage)
    end

    # 销售账单项
    def sell_money_item!(billing, workstation)
      workstation ||= Workstation.default
      Payment::SellPercentItem.create!(billing: billing,
                                       cash_account: workstation.cash_account,
                                       owner: workstation,
                                       amount: billing.sell_money,
                                       percent:  @lesson.sell_percentage)
    end

    # 发行账单项
    def publish_money_item!(billing, workstation)
      workstation ||= Workstation.default
      Payment::PublishPercentItem.create!(billing: billing,
                                          cash_account: workstation.cash_account,
                                          owner: workstation,
                                          amount: billing.publish_money,
                                          percent: @lesson.publish_percentage)
    end

    # 教师分成收入
    def teacher_money_item!(billing, teacher)
      Payment::TeacherMoneyItem.create(billing: billing,
                                       cash_account: teacher.cash_account,
                                       owner: teacher,
                                       amount: billing.teacher_money,
                                       percent: @lesson.teacher_percentage)
    end
  end
end
