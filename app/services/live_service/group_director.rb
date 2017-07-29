module LiveService
  class GroupDirector
    def initialize(group)
      @group = group
    end

    def self.search(search_params)
      chain = LiveStudio::CustomizedGroup.for_sell.includes(:teacher)
      chain = courses_filter_by_range(chain, *range_to_time(search_params[:range])) if search_params[:range].present?
      chain.ransack(search_params[:q])
    end

    private

    class << self
      private

      # 上课区间过滤
      def courses_filter_by_range(chain, start_time, end_time)
        return chain if start_time.nil? || end_time.nil?
        chain.where('(start_at BETWEEN :start AND :end OR end_at BETWEEN :start AND :end OR (start_at < :start AND end_at > :end))', start: start_time, end: end_time)
      end

      # 时间区间转换为时间点
      def range_to_time(range_name)
        return [] unless range_name =~ /\A\d+\_(month)|(year)|(day)|(week)s?\z/
        num, unit = range_name.split('_')
        [Time.now.beginning_of_day, num.to_i.send(unit).since.beginning_of_day]
      end
    end
  end
end
