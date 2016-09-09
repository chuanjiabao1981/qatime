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
      build_course_action_notifications(receiver_teacher)
    end

    # 辅导班开课发送消息
    def course_teaching
      build_course_action_notifications(all_receiver)
    end

    # 调课
    def lesson_change_class_date
      build_course_lesson_action_notifications(receiver_students)
    end

    # 上课提醒
    def lesson_teach
      build_course_lesson_action_notifications(all_receiver)
    end

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
      a = a + course.student_ids
      a = a << course.teacher_id
      a
    end

    def build_course_action_notifications(receivers)
      if receivers.is_a?(Array)
        receivers.each do |receiver_id|
          n = @course_active_record.course_action_notifications.build(action_name: @course_active_record.name, receiver_id: receiver_id, live_studio_course_id: @course_active_record.live_studio_course_id, live_studio_lesson_id: @course_active_record.live_studio_lesson_id)
          n.save
        end
      else
        n = @course_active_record.course_action_notifications.build(action_name: @course_active_record.name, receiver_id: receivers.to_s.to_i, live_studio_course_id: @course_active_record.live_studio_course_id, live_studio_lesson_id: @course_active_record.live_studio_lesson_id)
        n.save
      end
    end
  end
end
