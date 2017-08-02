
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

      def execute
        return unless _check_lesson
        billing = Payment::Billings::LessonBilling.create(target: @target, from_user: @target.teacher, created_at: @created_at)
        @target.ticket_items.billingable.map {|item| execute_item(billing, item) }
      rescue StandardError => e
        _billing_fail!(e)
        raise e
      end

      private

      def execute_item(parent, item)
        item.with_lock do
          ticket = ticket_item.ticket
          item_billing = _item_billing(parent, ticket)
          # 系统服务费收入
          system_fee_item!(item_billing)
          # 教师收入
          teacher_money_item!(item_billing, _target_teacher)
          # 发行商收入
          publish_money_item!(item_billing, _target_workstation)
          # 销售分销商收入
          sell_money_item!(item_billing, _ticket_seller(ticket))
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
        return @ticket_seller if @ticket_seller.present?
        @ticket_seller = ticket.seller || Workstation.default
      end

      def _item_billing(parent, ticket)
        Payment::Billings::TicketItemBilling.create!(target: @target, from_user: _target_teacher, parent: parent, ticket: ticket)
      end
    end
  end
end
