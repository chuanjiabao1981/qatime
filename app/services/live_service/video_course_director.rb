module LiveService
  class VideoCourseDirector
    def initialize(video_course)
      @video_course = video_course
    end

    # 检索条件: subject grade
    def self.search(search_params)
      chain = LiveStudio::VideoCourse.for_sell.includes(:video_lessons, :teacher)
      chain.ransack(search_params[:q])
    end

    def taste(user)
      return unless @video_course.taste_count > 0
      ticket = @video_course.taste_tickets.available.find_by(student: user)
      ticket ||= @video_course.taste_tickets.create(student: user, item_targets: @video_course.video_lessons.where(tastable: true))
      ticket
    end

    # 播放授权并记录播放记录
    def self.play_authorize!(user, video_lesson)
      return false if user.nil?
      return true unless user.student?
      ticket = video_lesson.video_course.tickets.available.find_by(student_id: user.id)
      return false if ticket.nil?
      # 记录播放记录
      LiveStudio::PlayRecord.init_play(user, video_lesson.video_course, video_lesson, ticket)
      # 上课进度
      ticket_item = ticket.ticket_items.find_by(target: video_lesson)
      ticket_item.use! if ticket_item && ticket_item.unused?
      ticket
    end
  end
end
