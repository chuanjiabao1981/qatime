module LiveService
  class InteractiveLessonNotificationSender
    def initialize(lesson)
      @lesson = lesson
    end

    def notice(action_name)
      return unless @lesson.class_date.today?
      receivers_of(action_name).each do |receiver|
        setting = receiver.notification_setting || NotificationSetting.default
        n = ::LiveStudioInteractiveLessonNotification.create(receiver: receiver, notificationable: @lesson, action_name: action_name)
        n.notify_by(:email) if setting.email
        n.notify_by(:message) if setting.message
      end
    end

    def schedule_notice(action_name)
      NotificationSenderJob.set(wait_until: @lesson.start_at - 30.minutes).perform_later(self.class.name, action_name.to_s, @lesson)
    end

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    private

    def start_for_teacher_receivers_of
      [@lesson.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def start_for_student_receivers_of
      @lesson.interactive_course.tickets.available.includes(student: :notification_setting).map(&:student)
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_teacher_receivers_of
      [@lesson.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_student_receivers_of
      @lesson.tickets.available.includes(student: :notification_setting).map(&:student)
    end
  end
end
