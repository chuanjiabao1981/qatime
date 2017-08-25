module LiveService
  class InteractiveCourseDirector
    # 一对一直播搜索
    # 检索条件: subject grade
    def self.search(search_params)
      chain = LiveStudio::InteractiveCourse.for_sell.includes(:interactive_lessons, :teachers)
      chain.ransack(search_params[:q])
    end

    # 清理全部完成的辅导班
    def self.clean_courses
      LiveStudio::InteractiveCourse.teaching.where("completed_lessons_count >= interactive_lessons_count").find_each(batch_size: 200).map(&:complete!)
    end
  end
end
