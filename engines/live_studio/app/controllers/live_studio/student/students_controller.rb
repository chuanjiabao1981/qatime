require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentsController < Student::BaseController
    layout 'v1/home'

    def schedules
      course_lessons = @student.live_studio_ticket_items.
                                where(class_date: Time.now.beginning_of_week..(Time.now.end_of_week + 1.day)).
                                where(target_type: 'LiveStudio::Lesson').includes(:ticket, target: :course)
      interactive_course_lessons = @student.live_studio_ticket_items.where(target_type: 'LiveStudio::InteractiveLesson').includes(:ticket, target: :interactive_course)

      @wait_lessons = course_lessons.unclosed.to_a + interactive_course_lessons.unclosed.to_a
      @close_lessons = course_lessons.already_closed.to_a + interactive_course_lessons.already_closed.to_a
      @wait_lessons = @wait_lessons.sort_by { |x| x.start_at }.reverse
      @close_lessons = @close_lessons.sort_by { |x| x.start_at }
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @student) || NotificationSetting.default
    end

    def tastes
      params[:cate] ||= 'courses'
      student_data = LiveService::StudentLiveDirector.new(@student)
      @taste_courses = student_data.tastes_by(params[:cate]).paginate(page: params[:page])
    end

    def taste_records
      student_data = LiveService::StudentLiveDirector.new(@student)
      @taste_records = student_data.taste_records.paginate(page: params[:page])
    end
  end
end
