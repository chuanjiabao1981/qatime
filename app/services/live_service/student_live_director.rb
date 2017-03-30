module LiveService
  class StudentLiveDirector
    def initialize(student)
      @student = student
    end

    # 我的直播
    def courses
      @student.live_studio_courses.includes(:teacher, :chat_team).reorder('live_studio_tickets.created_at desc')
    end

    # 分类查询我的直播
    def courses_of_cate(cate)
      return courses unless available_cates.include?(cate)
      send("courses_of_#{cate}")
    end

    # 我的一对一
    def interactive_courses
      @student.live_studio_interactive_courses.includes(:interactive_lessons, :chat_team, :teachers)
    end

    # 分类查询我的一对一
    def interactive_courses_of_cate(_cate)
      interactive_courses
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
