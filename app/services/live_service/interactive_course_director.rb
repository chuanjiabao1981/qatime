module LiveService
  class InteractiveCourseDirector
    # 一对一直播搜索
    # 检索条件: subject grade
    def self.search(search_params)
      chain = LiveStudio::InteractiveCourse.for_sell.includes(:interactive_lessons, :teachers)
      chain.ransack(search_params[:q])
    end
  end
end
