module LiveService
  class StudentCourseDirector
    def initialize(student)
      @student = student
    end

    def courses
      @student.live_studio_courses.includes(:teacher, :chat_team).reorder('live_studio_tickets.created_at desc')
    end

    def courses_of_cate(cate)
      return courses unless available_cates.include?(cate)
      send("courses_of_#{cate}")
    end

    private

    def courses_of_taste
      @student.live_studio_courses.includes(:teacher, :chat_team).where('live_studio_tickets.type = ?', 'LiveStudio::TasteTicket').reorder('live_studio_tickets.created_at desc')
    end

    # 弃用
    def courses_of_today
    end

    def available_cates
      %w(taste today)
    end
  end
end
