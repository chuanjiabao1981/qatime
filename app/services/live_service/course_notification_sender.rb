module LiveService
  class CourseNotificationSender
    def initialize(course)
      @course = course
    end

    def notice(action_name)
      receivers_of(action_name).each do |receiver|
        ::LiveStudioCourseNotification.create(receiver: receiver, notificationable: @course, action_name: action_name) if @course.is_a?(::LiveStudio::Course)
        ::LiveStudioInteractiveCourseNotification.create(receiver: receiver, notificationable: @course, action_name: action_name) if @course.is_a?(::LiveStudio::InteractiveCourse)
        ::LiveStudioGroupNotification.create(receiver: receiver, notificationable: @course, action_name: action_name) if @course.is_a?(::LiveStudio::Group)
      end
    end

    private

    # 通知接受者
    def receivers_of(action_name)
      send("#{action_name}_receivers_of")
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def assign_receivers_of
      [@course.teacher]
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def start_receivers_of
      receivers = @course.tickets.available.includes(:student).map(&:student)
      receivers << @course.teacher
      receivers
    end

    # 辅导班开课通知提醒者
    # Warning 学生数量太大的时候不要使用这种方式查询
    def notice_create_receivers_of
      @course.tickets.available.includes(:student).map(&:student)
    end
  end
end
