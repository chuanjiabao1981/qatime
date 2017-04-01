module BusinessService
  # 直播课结账
  class CourseBillingDirector
    def initialize(lesson, created_at = nil)
      @lesson = lesson
      @course = lesson.course
      @created_at = created_at || Time.now
    end

    # 课程结算
    def billing_lesson
      return unless _check_lesson
      # 课程总账单
      b = Payment::LiveCourseBilling.create(target: @lesson, from_user: @lesson.teacher, created_at: @created_at)
      # 针对每一个购买记录单独结账
      @lesson.ticket_items.billingable.includes(:ticket).each do |item|
        billing_ticket(b, item)
      end
      # 所有的购买记录都结账完成以后课程结账完成
      @lesson.complete! if @lesson.ticket_items.billingable.blank?
      b
    rescue StandardError => e
      _billing_fail!(e)
      raise e
    end

    # 购买记录单独结账
    # billing： 父账单
    def billing_ticket(parent, ticket_item)
      ticket_item.with_lock do
        ticket = ticket_item.ticket
        item_billing = _item_billing(parent, ticket)
        # 系统服务费收入
        system_fee_item!(item_billing)
        # 教师收入
        teacher_money_item!(item_billing, @lesson.teacher)
        # 发行商收入
        publish_money_item!(item_billing, @course.workstation)
        # 销售分销商收入
        sell_money_item!(item_billing, ticket.seller)
        # 系统分成收入
        platform_money_item!(item_billing)
        # 结账完成后购买记录修改状态，避免重复结账
        ticket_item.finish!
        # 这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
        yield if block_given?
      end
    end

    private

    # 给每一个购买记录生成一个单独的账单
    def _item_billing(parent, ticket)
      Payment::LiveCourseTicketBilling.create!(target: @lesson, from_user: @lesson.teacher, parent: parent, ticket: ticket, created_at: @created_at)
    end

    def _billing_fail!(e)
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "辅导班结账失败-#{@lesson.id}")
    end

    # 检查课程是否可以结账
    def _check_lesson
      # 检查课程老师信息
      @lesson.teacher = @course.teacher unless @lesson.teacher.present?
      # 检查课程时长
      @lesson.real_time = @lesson.live_sessions.sum(:duration) unless @lesson.real_time.to_i > 0
      @lesson.save
      # 结账前确保教师有资金账户
      @lesson.teacher.cash_account!
      @lesson.finished? || @lesson.billing?
    end

    # 系统服务费
    def system_fee_item!(billing)
      item = Payment::SystemFeeItem.create!(billing: billing,
                                            cash_account: CashAdmin.cash_account!,
                                            owner: CashAdmin.current!,
                                            amount: billing.base_fee,
                                            quantity: 1,
                                            price: @lesson.base_price,
                                            duration: @lesson.duration_minutes, created_at: @created_at)
      _cash_transfer(CashAdmin.cash_account!, billing.base_fee, item)
    end

    # 销售账单项
    def sell_money_item!(billing, workstation)
      workstation ||= Workstation.default
      item = Payment::SellPercentItem.create!(billing: billing,
                                              cash_account: workstation.cash_account,
                                              owner: workstation,
                                              amount: billing.sell_money,
                                              percent:  billing.sell_percentage, created_at: @created_at)
      _cash_transfer(workstation.cash_account, billing.sell_money, item)
    end

    # 平台分成账单项
    def platform_money_item!(billing)
      item = Payment::PlatformPercentItem.create!(billing: billing,
                                                  cash_account: CashAdmin.cash_account!,
                                                  owner: CashAdmin.current!,
                                                  amount: billing.platform_money,
                                                  percent:  billing.platform_percentage, created_at: @created_at)
      _cash_transfer(CashAdmin.cash_account!, billing.platform_money, item)
    end

    # 发行账单项
    def publish_money_item!(billing, workstation)
      workstation ||= Workstation.default
      item = Payment::PublishPercentItem.create!(billing: billing,
                                                 cash_account: workstation.cash_account,
                                                 owner: workstation,
                                                 amount: billing.publish_money,
                                                 percent: @lesson.publish_percentage, created_at: @created_at)
      _cash_transfer(workstation.cash_account, billing.publish_money, item)
    end

    # 教师分成收入
    def teacher_money_item!(billing, teacher)
      item = Payment::TeacherMoneyItem.create(billing: billing,
                                              cash_account: teacher.cash_account,
                                              owner: teacher,
                                              amount: billing.teacher_money,
                                              percent: @lesson.teacher_percentage, created_at: @created_at)
      _cash_transfer(teacher.cash_account, billing.teacher_money, item)
    end

    # 资金变动
    def _cash_transfer(target_account, amount, item)
      # 系统分账支出
      AccountService::CashManager.new(CashAdmin.cash_account!).decrease('Payment::SplitRecord', amount, item)
      # 收入记录
      AccountService::CashManager.new(target_account).increase('Payment::EarningRecord', amount, item)
    end
  end
end
