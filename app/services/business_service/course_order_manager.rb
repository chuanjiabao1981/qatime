# 业务模块
module BusinessService
  # 辅导班订单处理
  class CourseOrderManager
    def initialize(order)
      @order = order
    end

    # 结账
    def billing
      Payment::Order.transaction do
        @order.lock!
        _student_pay
        _system_sell
        @order.settle!
        yield if block_given?
      end
    end

    private

    # 系统生成销售记录
    def _system_sell
      AccountService::CashManager.new(CashAdmin.cash_account!).increase('Payment::SellRecord', @order.amount, @order)
    end

    # 学生生成消费记录
    def _student_pay
      student_account = @order.user.cash_account!
      student_cash_manager = AccountService::CashManager.new(student_account)
      if @order.account? # 余额支付
        student_cash_manager.decrease('Payment::ConsumptionRecord', @order.amount, @order)
        @order.pay!
      else # 第三方支付
        student_cash_manager.record_detail!('Payment::ConsumptionRecord', @order.amount, 0, @order)
      end
    end
  end
end
