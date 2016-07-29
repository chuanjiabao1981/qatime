require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    def index

      @tickets = @student.live_studio_tickets.includes(course: :teacher).includes(course: :lessons)
      @tickets =
          case params[:taxonomic]
            when 'all'
              @tickets.visiable
            when 'today'
              @tickets.select do |ticket|
                ticket.course.lessons.select do |lesson|
                  lesson.class_date == Date.today
                end.present?
              end
            when 'waiting'
              @tickets.select do |ticket|
                date = ticket.course.lessons.sort_by(&:class_date).first.try(:class_date)
                date && date > Date.today
              end
            when 'teaching'
              @tickets.select do |ticket|
                ticket.course.lessons.select do |lesson|
                  lesson.class_date >= Date.today
                end.present?
              end
            when 'closed'
              @tickets.select do |ticket|
                ticket.course.lessons.select do |lesson|
                  lesson.class_date >= Date.today
                end.blank?
              end
            when 'tasted'
              @student.live_studio_taste_tickets.includes(course: :teacher).includes(course: :lessons)
            else
              @tickets.visiable
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
  end
end
