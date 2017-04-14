module LiveService
  class VideoCourseDirector
    # 检索条件: subject grade
    def self.search(search_params)
      chain = LiveStudio::VideoCourse.for_sell.includes(:video_lessons, :teacher)
      chain.ransack(search_params[:q])
    end
  end
end
