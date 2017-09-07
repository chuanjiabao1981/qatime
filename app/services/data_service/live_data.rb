module DataService
  class LiveData
    def initialize(city_id = nil)
      @city_id = city_id
    end

    # 今日直播
    def today_lessons
      lessons = LiveStudio::Lesson.includes(:course).today.readied
      scheduled_lessons = LiveStudio::ScheduledLesson.includes(:group).today.readied
      (lessons.to_a + scheduled_lessons.to_a).sort_by(&:start_time)
    end

    # 免费课程
    def free_courses(options = {})
      limit = options.delete(:limit) || 4
      video_courses = LiveStudio::VideoCourse.for_sell.with_sell_type(:free).order(published_at: :desc).limit(options[:limit])
      courses = LiveStudio::Course.for_sell.with_sell_type(:free).order(published_at: :desc).limit(options[:limit])
      customized_groups = LiveStudio::CustomizedGroup.for_sell.with_sell_type(:free).order(published_at: :desc).limit(options[:limit])
      (video_courses.to_a + courses.to_a + customized_groups.to_a).sort_by(&:published_at).reverse.first(limit)
    end

    # 最新课程
    def latest_courses(options = {})
      LiveService::RankManager.mix_rank_of('published_rank', options.merge(city_id: @city_id))
    end
  end
end
