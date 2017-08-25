module LiveService
  class StudentLiveDirector
    def initialize(student)
      @student = student
    end

    # 我的直播
    def courses(options = {})
      return courses_of_cate(options[:cate]) if options[:cate].present?
      if options[:with_taste]
        courses = @student.live_studio_courses.includes(:teacher, :chat_team).reorder('live_studio_tickets.created_at desc')
      else
        courses = @student.live_studio_bought_courses.includes(:teacher, :chat_team).reorder('live_studio_tickets.created_at desc')
      end
      courses = courses.where(status: LiveStudio::Course.statuses[options[:status]]) if options[:status]
      courses
    end

    # 分类查询我的直播
    def courses_of_cate(cate)
      return courses unless available_cates.include?(cate)
      send("courses_of_#{cate}")
    end

    # 我的一对一
    def interactive_courses(options = {})
      interactive_courses = @student.live_studio_interactive_courses.includes(:interactive_lessons, :chat_team, :teachers)
      interactive_courses = interactive_courses.unscope(where: :status).where(status: LiveStudio::InteractiveCourse.statuses[options[:status]]) if options[:status]
      interactive_courses
    end

    # 分类查询我的一对一
    def interactive_courses_of_cate(_cate)
      interactive_courses
    end

    # 我的购买的视频课
    def video_courses(options = {})
      courses = @student.live_studio_bought_video_courses.includes(:video_lessons, :teacher)
      sell_type_value = LiveStudio::VideoCourse.sell_type.find_value(options[:sell_type]).try(:value)
      courses = courses.where(sell_type: sell_type_value) if sell_type_value
      courses
    end

    # 我的试听
    def tastes_by(cate)
      return @student.live_studio_taste_courses.none unless %w[courses video_courses].include?(cate)
      send("#{cate}_of_taste")
    end

    # 试听记录
    def taste_records
      ticket_ids = @student.live_studio_taste_ticket_ids
      @student.live_studio_play_records.where(ticket_id: ticket_ids).select("DISTINCT ON(ticket_id) *").order("ticket_id, created_at DESC").to_a.sort.reverse
    end

    private

    def courses_of_taste
      @student.live_studio_taste_courses.includes(:teacher, :chat_team).where('live_studio_tickets.type = ?', 'LiveStudio::TasteTicket').reorder('live_studio_tickets.created_at desc')
    end

    def video_courses_of_taste
      @student.live_studio_taste_video_courses.includes(:teacher).where('live_studio_tickets.type = ?', 'LiveStudio::TasteTicket').reorder('live_studio_tickets.created_at desc')
    end

    # 弃用
    def courses_of_today
    end

    def available_cates
      %w(taste today)
    end
  end
end
