module LiveService
  class BillingDirector
    def initialize(lesson)
      @lesson = lesson
      @course = lesson.course
    end

    # 课程结算
    def billing
      return unless check_lesson
      billing_class.create(target: @lesson, from_user: @lesson.teacher).billing
    rescue StandardError => e
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: "辅导班结账失败")
    end

    private

    def check_lesson
      # 检查课程老师信息
      @lesson.teacher = @course.teacher unless @lesson.teacher.present?
      # 检查课程时长
      @lesson.real_time = @lesson.live_sessions.sum(:duration) unless @lesson.real_time.to_i > 0
      @lesson.save
      @lesson.finished? || @lesson.billing?
    end

    def billing_class
      @course.billing_type.constantize
    end
  end
end
