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
      LiveService::ChatAccountFromUser.new(user).instance_account
      @video_course.taste_tickets.find_or_create_by(student: user)
    end
  end
end
