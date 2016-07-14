module LiveStudio
  class CourseTicketCleanerJob < ActiveJob::Base
    queue_as :live_studio

    def perform(lesson_id)
      @lesson = LiveStudio::Lesson.find(lesson_id)
      @course = @lesson.course
      used_student_ids = []
      @course.tickets.available.find_each do |ticket|
        inc_used_count(ticket, used_student_ids)
      end
      Chat::TeamMemberCleanerJob.perform_later(used_student_ids)
    end

    private

    def inc_used_count(ticket, used_student_ids)
      ticket.used_count += 1
      if ticket.used_count >= ticket.buy_count
        ticket.status = LiveStudio::Ticket.statuses[:used]
        used_student_ids << ticket.student_id if ticket.taste?
      end
      ticket.save
    end
  end
end
