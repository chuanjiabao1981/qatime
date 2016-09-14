module LiveService
  class LessonNotificationSender
    def initialize(lesson)
      @lesson = lesson
    end

    def notice(action_name)
      receivers_of(action_name).each do |receiver|
        ::LiveStudioLessonNotification.create(receiver: receiver, notificationable: @lesson, action_name: action_name)
      end
    end

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    private

    def start_for_teacher_receivers_of
      [@lesson.course.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def start_for_student_receivers_of
      @lesson.course.tickets.available.includes(:student).map(&:student)
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_teacher_receivers_of
      [@lesson.course.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_student_receivers_of
      @lesson.course.tickets.available.includes(:student).map(&:student)
    end
  end
end
