module LiveService
  class CourseNotificationSender
    def initialize(course)
      @course = course
    end

    def notice(action_name)
      receivers_of(action_name).each do |receiver|
        ::LiveStudioCourseNotification.create(receiver: receiver, notificationable: @course, action_name: :ready)
      end
    end

    private

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def ready_receivers_of
      receivers = @course.tickets.available.includes(:student).map(&:student)
      receivers.unshift(@course.teacher)
      receivers
    end
  end
end
