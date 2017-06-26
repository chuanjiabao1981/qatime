module LiveService
  # 课程表服务
  module ScheduleService
    def schedule_for(user)
      case user
      when Student
        StudentSchedule.new(user)
      when Teacher
        TeacherSchedule.new(user)
      end
    end
    module_function :schedule_for

    # 课程表基础类
    class Base
      def initialize(user)
        @user = user
      end

      def month(date = nil)
        send("#{@user.role}_schedule_items", month_of(date)) if @user.student_or_teacher?
      end

      def week(date = nil)
        send("#{@user.role}_schedule_items", week_of(date)) if @user.student_or_teacher?
      end

      private

      def month_of(date)
        date ||= Time.now
        date.beginning_of_month.to_date..date.end_of_month.to_date
      end

      def week_of(date)
        date ||= Time.now
        date.beginning_of_week.to_date..date.end_of_week.to_date
      end
    end

    # 教师课程表
    class TeacherSchedule < Base
      private

      def teacher_schedule_items(range)
        course_lessons = @user.live_studio_lessons.includes(:course).where(class_date: range)
        interactive_course_lessons = @user.live_studio_interactive_lessons.includes(:interactive_course).where(class_date: range)
        course_lessons.to_a + interactive_course_lessons.to_a
      end
    end

    # 学生课程表
    class StudentSchedule < Base
      private

      def student_schedule_items(range)
        lessons_items = lessons_ticket_items.where('live_studio_lessons.class_date' => range)
        interactive_lessons_items = interactive_lessons_ticket_items.where('live_studio_interactive_lessons.class_date' => range)
        lessons_items.to_a + interactive_lessons_items.to_a
      end

      def lessons_ticket_items
        @user.live_studio_ticket_items.available.where(target_type: 'LiveStudio::Lesson').includes(:ticket, target: :course)
             .joins('left join live_studio_lessons on live_studio_lessons.id = live_studio_ticket_items.target_id')
      end

      def interactive_lessons_ticket_items
        @user.live_studio_ticket_items.available.where(target_type: 'LiveStudio::InteractiveLesson').includes(:ticket, target: :interactive_course)
             .joins('left join live_studio_interactive_lessons on live_studio_interactive_lessons.id = live_studio_ticket_items.target_id')
      end
    end
  end
end
