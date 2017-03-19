module LiveService
  class RankManager
    class << self
      def rank_of(rank_name, options = {})
        send(rank_name, options)
      end

      private

      # 发布时间排行
      def published_rank(_options)
        base_filter.reorder('published_at desc')
      end

      # 开始时间排行
      def start_rank(_options)
        base_filter.where('status = ?', ::LiveStudio::Course.statuses[:published]).reorder('start_at')
      end

      def base_filter
        LiveStudio::Course.for_sell
      end
    end
  end
end
