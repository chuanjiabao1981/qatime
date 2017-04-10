# 业务模块
module BusinessService
  # 退款处理
  class RefundManager
    def initialize(refund)
      @refund = refund
    end

    # 结账
    def billing
      Payment::Refund.transaction do
        @refund.lock!
        _user_receive
        _system_pay
        _product_refund_hook
        yield if block_given?
      end
    rescue StandardError => e
      p e.message
      p e.backtrace.join("\n")
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "退款操作失败-#{@refund.id}")
    end

    private

    # 用户收款
    def _user_receive
      user_account = @refund.user.cash_account!
      user_cash_manager = AccountService::CashManager.new(user_account)
      if @refund.account? # 退款到余额
        user_cash_manager.increase('Payment::RefundRecord', @refund.amount, @refund)
        @refund.transfer!
      else # 第三方支付
        user_cash_manager.record_detail!('Payment::RefundRecord', @refund.amount, 0, @refund)
        @refund.remote_refund! # 提交退款申请
      end
    end

    # 系统扣款
    def _system_pay
      AccountService::CashManager.new(CashAdmin.cash_account!).decrease('Payment::RefundPayRecord', @refund.amount, @refund)
    end

    # 退款后期处理
    # 一对一退款以后课程提前结束
    def _product_refund_hook
      return if @refund.product.nil? || !@refund.product.is_a?(LiveStudio::InteractiveCourse)
      return unless @refund.product.try(:refund!)
      # 提前结束以后给老师发送结束通知
      @refund.product.teachers.each do |teacher|
        p ::LiveStudioInteractiveCourseNotification.create!(receiver: teacher, notificationable: @refund.product, action_name: :finish)
      end
    end
  end
end
