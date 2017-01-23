module LiveService
  class BillingDirector
    def initialize(lesson)
      @lesson = lesson
      @course = lesson.course
    end

    # 课程结算
    def billing
      return unless check_lesson
      Payment::LiveCourseBilling.transaction do
        Payment::LiveCourseBilling.new(target: @lesson).calculate.billing
        @lesson.complete!
      end
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
  end
end
