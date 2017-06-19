require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentsController < Student::BaseController
    layout 'v1/home'

    def schedules
      lessons_ticket_items = @student.live_studio_ticket_items.available.where(target_type: 'LiveStudio::Lesson').includes(:ticket, target: :course)
      lessons_ticket_items = lessons_ticket_items.joins('left join live_studio_lessons on live_studio_lessons.id = live_studio_ticket_items.target_id').where('live_studio_lessons.class_date' => this_week)
      interactive_lessons_ticket_items = @student.live_studio_ticket_items.available.where(target_type: 'LiveStudio::InteractiveLesson').includes(:ticket, target: :interactive_course)
      interactive_lessons_ticket_items = interactive_lessons_ticket_items.joins('left join live_studio_interactive_lessons on live_studio_interactive_lessons.id = live_studio_ticket_items.target_id').where('live_studio_interactive_lessons.class_date' => this_week)

      @close_lessons = (lessons_ticket_items + interactive_lessons_ticket_items).select { |item| item.target.unclosed? }.sort_by { |item| item.target.start_at }.reverse
      @wait_lessons = (lessons_ticket_items + interactive_lessons_ticket_items).select { |item| item.target.already_closed? }.sort_by { |item| item.target.start_at }
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

    private

    def this_week
      Time.now.beginning_of_week..(Time.now.end_of_week + 1.days)
    end
  end
end
