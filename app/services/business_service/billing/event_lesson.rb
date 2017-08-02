module BusinessService
  module Billing
    # 收费课程结账
    class EventLesson < Base
      private
      def _check_lesson
        # 检查课程老师信息
        @target.teacher = @target.group.teacher unless @target.teacher.present?
        # 检查课程时长
        @target.real_time = @target.live_sessions.sum(:duration) unless @target.real_time.to_i > 0
        @target.save
        # 结账前确保教师有资金账户
        @target.teacher.cash_account!
        @target.waiting_billing?
      end
    end
  end
end
