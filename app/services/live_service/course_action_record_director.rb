module LiveService
  class CourseActionRecordDirector
    def initialize(course_active_record)
      @course_active_record = course_active_record
    end

    def create_action_notification
      # 如果没有course就不创建这个消息
      return unless course

      send @course_active_record.category.to_s.to_sym
    end

    # 创建辅导班，发送消息
    def course_create
      n = @course_active_record.course_action_notifications.build(action_name: @course_active_record.name, receiver_id: receiver_teacher)
      n.save
    end

    # 辅导班开课发送消息
    def course_teaching
      all_receiver.each do |receiver_id|
        n = @course_active_record.course_action_notifications.build(action_name: @course_active_record.name, receiver_id: receiver_id)
        n.save
      end
    end

    # 上课提醒
    # def lesson_teach
    #   course.
    # end

    # 修改辅导班公告，发送消息
    def update_notice
      receiver_students.each do |receiver_id|
        n = @course_active_record.course_action_notifications.build(action_name: @course_active_record.name, receiver_id: receiver_id)
        n.save
      end
    end

    private

    def course
      @course_active_record.live_studio_course
    end

    def receiver_teacher
      course.teacher_id
    end

    def receiver_students
      course.student_ids
    end

    def all_receiver
      a = []
      a = a +  course.teacher_id
      a = a << course.student_ids
      a
    end
  end
end
