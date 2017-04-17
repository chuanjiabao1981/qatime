module BusinessService
  # 一对一直播课结账
  class VideoCourseBillingDirector
    def initialize(ticket)
      @ticket = ticket
      @video_course = @ticket.product
    end

    # 课程结算
    def billing_ticket
      return unless _check_ticket
      order = @ticket.payment_order
      order.with_lock do
        # 课程总账单
        billing = Payment::VideoCourseBilling.create(ticket: @ticket, target: @video_course, from_user: @video_course.teacher)
        # 系统服务费收入
        # binding.pry
        system_fee_item!(billing)
        # 教师收入
        teacher_money_item!(billing, @video_course.teacher)
        # 发行商收入
        publish_money_item!(billing, @video_course.workstation)
        # 销售分销商收入
        sell_money_item!(billing, @ticket.seller)
        # 系统分成收入
        platform_money_item!(billing)
        # 结账完成后购买记录修改状态，避免重复结账
        raise ActiveRecord::Rollback, "订单保存失败!" unless order.finish!
        # 这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
        yield if block_given?
      end
    rescue StandardError => e
      _billing_fail!(e)
      raise e
    end

    private

    def _billing_fail!(e)
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "视频课结账失败-#{@ticket.id}")
    end

    # 检查课程是否可以结账
    def _check_ticket
      true
    end

    # 系统服务费
    def system_fee_item!(billing)
      item = Payment::SystemFeeItem.create!(billing: billing,
                                            cash_account: CashAdmin.cash_account!,
                                            owner: CashAdmin.current!,
                                            amount: billing.base_fee,
                                            quantity: 1,
                                            price: @video_course.base_price,
                                            duration: @video_course.duration_minutes, created_at: @created_at)
      _cash_transfer(CashAdmin.cash_account!, billing.base_fee, item)
    end

    # 销售账单项
    def sell_money_item!(billing, workstation)
      workstation ||= Workstation.default
      item = Payment::SellPercentItem.create!(billing: billing,
                                              cash_account: workstation.cash_account!,
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
                                                 cash_account: workstation.cash_account!,
                                                 owner: workstation,
                                                 amount: billing.publish_money,
                                                 percent: @video_course.publish_percentage, created_at: @created_at)
      _cash_transfer(workstation.cash_account, billing.publish_money, item)
    end

    # 教师分成收入
    def teacher_money_item!(billing, teacher)
      item = Payment::TeacherMoneyItem.create(billing: billing,
                                              cash_account: teacher.cash_account!,
                                              owner: teacher,
                                              amount: billing.teacher_money,
                                              percent: @video_course.teacher_percentage, created_at: @created_at)
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
