module LiveService
  class LiveService
    class << self
      def tickets_for_cate(student,cate)
        @tickets = student.live_studio_tickets.visiable.includes(course: :teacher).includes(course: :lessons)
        case cate
          when 'today'
            @tickets.select do |ticket|
              ticket.course.lessons.select do |lesson|
                lesson.class_date == Date.today
              end.present?
            end
          when 'waiting'
            set_tickets(:preview)
          when 'teaching'
            set_tickets(:teaching)
          when 'closed'
            set_tickets(:completed)
          when 'tasted'
            student.live_studio_taste_tickets.includes(course: :teacher).includes(course: :lessons)
          else
            @tickets
        end
      end

      private
      def set_tickets(status)
        @tickets.where(live_studio_courses: {status: LiveStudio::Course.statuses[status]})
      end
    end
  end
end
