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
        # 系统服务费收入
        system_fee_item!(item_billing)
        # 教师收入
        teacher_money_item!(item_billing, @lesson.teacher)
        # 发行商收入
        publish_money_item!(item_billing, @course.workstation)
        # 销售分销商收入
        sell_seller_money_item!(item_billing, ticket.seller)
        # 跨区销售系统收入
        sell_system_money_item!(item_billing)
        # 系统分成收入
        system_money_item!(item_billing)
        # 结账完成后购买记录修改状态，避免重复结账
        ticket_item.finish!
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
      @system_account ||= CashAdmin.cash_account!
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
      cash_transfer(account)
    end

    # 系统分成收入
    def system_money_item!(billing)
      Payment::SystemPercentItem.create!(billing: billing,
                                         cash_account: system_account,
                                         owner: CashAdmin.current!,
                                         amount: billing.system_money,
                                         percent: @lesson.system_percentage)
      _cash_transfer(system_account, billing.system_money, billing, item)
    end

    # 销售账单项
    def sell_seller_money_item!(billing, workstation)
      workstation ||= Workstation.default
      item = Payment::SellPercentItem.create!(billing: billing,
                                              cash_account: workstation.cash_account,
                                              owner: workstation,
                                              amount: billing.sell_seller_money,
                                              percent:  billing.sell_seller_percentage)
      _cash_transfer(workstation.cash_account, billing.sell_seller_money, billing, item)
    end

    # 跨区销售系统分成
    def sell_system_money_item!(billing)
      item = Payment::CrossRegionPercentItem.create!(billing: billing,
                                                     cash_account: system_account,
                                                     owner: CashAdmin.current!,
                                                     amount: billing.sell_system_money,
                                                     percent:  billing.sell_system_percentage)
      _cash_transfer(system_account, billing.sell_system_money, billing, item)
    end

    # 发行账单项
    def publish_money_item!(billing, workstation)
      workstation ||= Workstation.default
      item = Payment::PublishPercentItem.create!(billing: billing,
                                                 cash_account: workstation.cash_account,
                                                 owner: workstation,
                                                 amount: billing.publish_money,
                                                 percent: @lesson.publish_percentage)
      _cash_transfer(workstation.cash_account, billing.publish_money, billing, item)
    end

    # 教师分成收入
    def teacher_money_item!(billing, teacher)
      item = Payment::TeacherMoneyItem.create(billing: billing,
                                              cash_account: teacher.cash_account,
                                              owner: teacher,
                                              amount: billing.teacher_money,
                                              percent: @lesson.teacher_percentage)
      _cash_transfer(teacher.cash_account, billing.teacher_money, billing, item)
    end

    # 资金变动
    def _cash_transfer(target_account, amount, billing, item)
      from_account = system_account
      Payment::CashAccount.transaction do
        from_account.lock!
        target_account.lock!
        _transfer_pay(from_account, amount, billing, item)
        _transfer_income(target_account, amount, billing, item)
        from_account.save!
        target_account.save!
      end
    end

    # 账户支出
    # 学生购买辅导班资金进入不可提现余额，分账需要从不可提现余额扣款
    def _transfer_pay(account, amount, billing, item)
      account.balance -= amount # 总金额减少
      account.unavailable_balance -= amount # 不可用金额减少
      # 记录账户明细 账单分账
      account.record_detail!(:split_pay_reacords, amount, billing: billing, billing_item: item)
    end

    # 账户收入
    # 工作站账户收入进入不可提现余额
    def _transfer_income(account, amount, billing, item)
      account.balance += amount # 总余额
      account.total_income += amount
      account.is_a?(Workstation) ? _unavailable_income(amount) : _available_income(amount)
      # 记录账户明细 账户收入
      account.record_detail!(:earning_records, amount, billing: billing, billing_item: item)
    end

    # 不可提现收入
    def _unavailable_income(account, amount)
      account.unavailable_balance += amount # 可用余额
    end

    # 可提现收入
    def _available_income(account, amount)
      account.available_balance += amount # 可用余额
    end
  end
end
