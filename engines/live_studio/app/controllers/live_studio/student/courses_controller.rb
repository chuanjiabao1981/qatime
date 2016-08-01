require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    def index

      @tickets = @student.live_studio_tickets.visiable.joins('left join live_studio_courses on live_studio_tickets.course_id = live_studio_courses.id').
          includes(course: :teacher).includes(course: :lessons)
      @tickets =
          case params[:filter]
            when 'today'
              @tickets.select do |ticket|
                ticket.course.lessons.select do |lesson|
                  lesson.class_date == Date.today
                end.present?
              end
            when 'waiting'
              tickets(:preview)
            when 'teaching'
              tickets(:teaching)
            when 'closed'
              tickets(:completed)
            when 'tasted'
              @student.live_studio_taste_tickets.includes(course: :teacher).includes(course: :lessons)
            else
              @tickets
          end
      @tickets = @tickets.paginate(page: params[:per_page])
    end

    def show
      @course = Course.find(params[:id])
      @ticket = @student.live_studio_tickets.visiable.find_by(course_id: params[:id])
      @lessons = @course.lessons.order(:id).paginate(page: params[:page])
      @play_records = PlayRecord.where(user_id: @student.id, lesson_id: @lessons.map(&:id))
      @play_hash = @play_records.inject({}){ |hash, v| hash[v.lesson_id] = v.id; hash }
    end

    private
    def tickets(course_status)
      @tickets.where('live_studio_courses.status = ?', LiveStudio::Course.statuses[course_status])
    end
  end
end
