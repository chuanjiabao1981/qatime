# 业务模块
module TransactionService
  # 订单处理
  class OrderManager
    def initialize(order)
      @order = order
    end

    # 结账
    def billing
      Payment::Order.transaction do
        _system_sell
        _student_pay
        yield if block_given?
      end
    end

    private

    # 系统生成销售记录
    def _system_sell
      Payment::CashManager.new(CashAdmin.cash_account!).increase('Payment::SellRecord', @order.amount, @order)
    end

    # 学生生成消费记录
    def _student_pay
      student_account = @order.user.cash_account!
      student_cash_manager = Payment::CashManager.new(student_account)
      if @order.account? # 余额支付
        student_cash_manager.decrease('Payment::ConsumptionRecord', @order.amount, @order)
      else # 第三方支付
        student_cash_manager.record_detail!('Payment::ConsumptionRecord', @order.amount, 0, @order)
        student_account.save!
      end
    end
  end
end
