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

    private

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def start_receivers_of
      receivers = @lesson.course.tickets.available.includes(:student).map(&:student)
      receivers << @lesson.course.teacher
      receivers
    end
  end
end
