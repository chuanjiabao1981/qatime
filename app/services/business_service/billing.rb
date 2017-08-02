
# 业务模块
module BusinessService
  # 结账模块
  module Billing
    extend ActiveSupport::Autoload
    autoload :EventLesson

    # 结账基础类
    class Base
      def initialize(target)
        @target = target
      end

      def execute!
        return unless _check_lesson
        billing = Payment::Billings::LessonBilling.create(target: @target, from_user: @target.teacher, created_at: @created_at)
        @target.ticket_items.billingable.map {|item| execute_item(billing, item) }
        @target.complete! if @target.ticket_items.billingable.blank?
      rescue StandardError => e
        _billing_fail!(e)
        raise e
      end

      private

      def execute_item(parent, item)
        item.with_lock do
          ticket = item.ticket
          item_billing = _item_billing(parent, ticket)
          # 系统服务费收入
          system_fee_item!(item_billing)
          # 教师收入
          teacher_money_item!(item_billing)
          # 发行商收入
          publish_money_item!(item_billing)
          # 销售分销商收入
          sell_money_item!(item_billing)
          # 系统分成收入
          platform_money_item!(item_billing)
          # 结账完成后购买记录修改状态，避免重复结账
          item.finish!
          # 这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
          yield if block_given?
        end
      end

      # 资金变动
      def _cash_transfer(account, amount, item)
        # 系统分账支出
        AccountService::CashManager.new(_system_account).decrease('Payment::SplitRecord', amount, item)
        # 收入记录
        AccountService::CashManager.new(account).increase('Payment::EarningRecord', amount, item)
      end

      # 系统账户
      def _system_account
        CashAdmin.cash_account!
      end

      def _billing_fail!(e)
        Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
        SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "#{@target.model_name.human}-#{@target.id}结账错误")
      end

      # 教师
      def _target_teacher
        @target.teacher
      end

      # 发行工作站
      def _target_workstation
        @target.workstation
      end

      # 销售工作站
      def _ticket_seller(ticket)
        ticket.seller || Workstation.default
      end

      def _item_billing(parent, ticket)
        Payment::Billings::TicketItemBilling.create!(target: @target, from_user: _target_teacher, parent: parent, ticket: ticket)
      end

      def _check_lesson
        true
      end

      # 系统服务费
      def system_fee_item!(billing)
        item = Payment::SystemFeeItem.create!(
          billing: billing,
          cash_account: _system_account,
          owner: CashAdmin.current!,
          amount: billing.base_fee,
          quantity: 1,
          price: @target.base_price,
          duration: @target.duration_hours * 60
        )
        _cash_transfer(_system_account, billing.base_fee, item)
      end

      # 销售账单项
      def sell_money_item!(billing)
        item = Payment::SellPercentItem.create!(
          billing: billing,
          cash_account: _ticket_seller(billing.ticket).cash_account,
          owner: _ticket_seller(billing.ticket),
          amount: billing.sell_money,
          percent:  billing.sell_percentage
        )
        _cash_transfer(_ticket_seller(billing.ticket).cash_account, billing.sell_money, item)
      end

      # 平台分成账单项
      def platform_money_item!(billing)
        item = Payment::PlatformPercentItem.create!(
          billing: billing,
          cash_account: _system_account,
          owner: CashAdmin.current!,
          amount: billing.platform_money,
          percent:  billing.platform_percentage
        )
        _cash_transfer(_system_account, billing.platform_money, item)
      end

      # 发行账单项
      def publish_money_item!(billing)
        item = Payment::PublishPercentItem.create!(
          billing: billing,
          cash_account: _target_workstation.cash_account,
          owner: _target_workstation,
          amount: billing.publish_money,
          percent: @target.publish_percentage
        )
        _cash_transfer(_target_workstation.cash_account, billing.publish_money, item)
      end

      # 教师分成收入
      def teacher_money_item!(billing)
        item = Payment::TeacherMoneyItem.create(
          billing: billing,
          cash_account: _target_teacher.cash_account,
          owner: _target_teacher,
          amount: billing.teacher_money,
          percent: @target.teacher_percentage
        )
        _cash_transfer(_target_teacher.cash_account, billing.teacher_money, item)
      end
    end
  end
end
