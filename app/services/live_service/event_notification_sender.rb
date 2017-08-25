module LiveService
  class EventNotificationSender
    def initialize(lesson)
      @lesson = lesson
    end

    def notice(action_name)
      receivers_of(action_name).each do |receiver|
        setting = receiver.notification_setting || NotificationSetting.default
        n = ::LiveStudioEventNotification.create(receiver: receiver, notificationable: @lesson, action_name: action_name)
        n.notify_by(:email) if setting.email
        n.notify_by(:message) if setting.message
      end
    end

    # 异步发送通知
    def notice_with_asyn(action_name, immediately = false)
      return notice_without_asyn(action_name) if immediately
      NotificationSenderJob.perform_later(self.class.name, action_name.to_s, @lesson)
    end
    alias_method_chain :notice, :asyn

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    private

    def start_for_teacher_receivers_of
      [@lesson.group.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def start_for_student_receivers_of
      @lesson.group.tickets.available.includes(student: :notification_setting).map(&:student)
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_teacher_receivers_of
      [@lesson.group.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def miss_for_student_receivers_of
      @lesson.group.tickets.available.includes(student: :notification_setting).map(&:student)
    end
  end
end
