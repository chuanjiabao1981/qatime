module LiveService
  class RankManager
    class << self
      def rank_of(rank_name, options = {})
        send(rank_name, options)
      end

      private

      # 所有课程 最新发布
      def all_published_rank(options)
        options[:limit] ||= 4
        options[:sort_by] ||= 'published_at desc'
        all_base_filter(options).sort_by{|x| x.published_at || Time.new(2000) }.reverse.to(options[:limit] - 1)
      end

      def all_published_rank_old(options)
        options[:limit] ||= 4
        options[:sort_by] ||= 'published_at desc'
        all_base_filter_old(options).sort_by{|x| x.published_at || Time.new(2000) }.reverse.to(options[:limit] - 1)
      end

      # 发布时间排行
      def published_rank(options)
        base_filter(options).reorder('published_at desc')
      end

      # 开始时间排行
      def start_rank(options)
        base_filter(options).where('status = ?', ::LiveStudio::Course.statuses[:published]).reorder('start_at')
      end

      def base_filter(options)
        filter = LiveStudio::Course.for_sell
        filter = filter.where(city_id: options[:city_id]) if options[:city_id].present?
        filter
      end

      def all_base_filter(options)
        options[:limit] ||= 4
        options[:sort_by] ||= 'id desc'
        courses = LiveStudio::Course.for_sell.order(options[:sort_by])
        interactive_courses = LiveStudio::InteractiveCourse.for_sell.order(options[:sort_by])
        video_courses = LiveStudio::VideoCourse.for_sell.order(options[:sort_by])
        customized_groups = LiveStudio::CustomizedGroup.for_sell.order(options[:sort_by])
        if options[:city_id].present?
          courses = courses.where(city_id: options[:city_id])
          interactive_courses = interactive_courses.where(city_id: options[:city_id])
          video_courses = video_courses.where(city_id: options[:city_id])
          customized_groups = customized_groups.where(city_id: options[:city_id])
        end
        courses.limit(options[:limit]).to_a + interactive_courses.limit(options[:limit]).to_a + video_courses.limit(options[:limit]).to_a + customized_groups.limit(options[:limit]).to_a
      end

      def all_base_filter_old(options)
        options[:limit] ||= 4
        options[:sort_by] ||= 'id desc'
        courses = LiveStudio::Course.for_sell.order(options[:sort_by])
        interactive_courses = LiveStudio::InteractiveCourse.for_sell.order(options[:sort_by])
        video_courses = LiveStudio::VideoCourse.for_sell.order(options[:sort_by])
        if options[:city_id].present?
          courses = courses.where(city_id: options[:city_id])
          interactive_courses = interactive_courses.where(city_id: options[:city_id])
          video_courses = video_courses.where(city_id: options[:city_id])
        end
        courses.limit(options[:limit]).to_a + interactive_courses.limit(options[:limit]).to_a + video_courses.limit(options[:limit]).to_a
      end
    end
  end
end
