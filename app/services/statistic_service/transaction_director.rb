module StatisticService
  class TransactionDirector

    def initialize(statistics, statistics_days, time_now)
      @statistics = statistics
      @statistics_days = statistics_days
      @time_now = time_now
    end

    def search(params)
      case @statistics_days
        when 'week' # 7天
          @start_time = @time_now.at_beginning_of_day - 7.days
          @end_time = @time_now.at_end_of_day
          # X轴日期
          @dates = (@start_time.to_date..@end_time.to_date).to_a
          # 日期统计
          @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        when 'month' # 4周
          @start_time = @time_now.at_beginning_of_day - 1.month
          @end_time = @time_now.at_end_of_day
          @dates = (@start_time.to_date..@end_time.to_date).select {|x| x.monday?}
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        when 'month2' # 8周
          @start_time = @time_now.at_beginning_of_day - 2.months
          @end_time = @time_now.at_end_of_day
          @dates = (@start_time.to_date..@end_time.to_date).select {|x| x.monday?}
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        when 'month3' # 12周
          @start_time = @time_now.at_beginning_of_day - 3.months
          @end_time = @time_now.at_end_of_day
          @dates = (@start_time.to_date..@end_time.to_date).select {|x| x.monday?}
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        when 'month6' # 6月
          @start_time = @time_now.at_beginning_of_day - 6.months
          @end_time = @time_now.at_end_of_day
          # 每月1号代表统计
          @dates = (@start_time.to_date..@end_time.to_date).select { |x| x.day == 1 }
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        when 'year' # 12月
          @start_time = @time_now.at_beginning_of_day - 1.year
          @end_time = @time_now.at_end_of_day
          @dates = (@start_time.to_date..@end_time.to_date).select { |x| x.day == 1 }
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
        else
          @start_time = @time_now.at_beginning_of_day - 7.days
          @end_time = @time_now.at_end_of_day
          # X轴日期
          @dates = (@start_time.to_date..@end_time.to_date).to_a
          # 日期统计
          @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_time..@end_time)).group("group_date")
      end
    end

    # 明细数据
    def results
      @statistics.includes(:product, :user).where(created_at: (@start_time..@end_time))
    end

    # x轴数列
    def x_cate
      # 月份显示
      if %w[month6 year].include?(@statistics_days)
        @dates.inject([]) { |r, v| r << v.strftime("%Y-%m") }
      else
        @dates.inject([]) { |r, v| r << v.strftime("%m-%d") }
      end
    end

    # y轴数据项[]
    def series_data
      @dates.inject([]) { |r, v| r << (@date_statistics.find{ |x| x.group_date.to_date == v }.try(:amount_sum).presence || 0) }
    end

    # 统计销售总额 销售总额-退款总额
    def sales_total(orders, refunds)
      orders.where(created_at: (@start_time..@end_time)).sum(:amount) - refunds.where(created_at: (@start_time..@end_time)).sum(:amount)
    end

    # 统计 预计销售收入额 销售收入增加-销售收入减少
    def profit_total(orders, refunds)
      orders.includes(:product).where(created_at: (@start_time..@end_time)).map(&:profit_amount).sum - refunds.includes(:product).where(created_at: (@start_time..@end_time)).map(&:profit_amount).sum
    end

  end
end
