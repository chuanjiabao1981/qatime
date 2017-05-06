module LiveService
  class RankManager
    class << self
      def rank_of(rank_name, options = {})
        send(rank_name, options)
      end

      private

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
    end
  end
end
