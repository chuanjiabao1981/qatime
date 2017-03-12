module StatisticService
  class TransactionDirector

    def initialize(statistics, statistics_days, date_now)
      @statistics = statistics
      @statistics_days = statistics_days
      @date_now = date_now
    end

    def search(params)
      case @statistics_days
        when 'week' # 7天
          @start_day = @date_now.last_week.at_beginning_of_week
          @end_day = @date_now.last_week.at_end_of_week
          # X轴日期
          @dates = (@start_day..@end_day).to_a
          # 日期统计
          @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        when 'month' # 4周
          @start_day = @date_now.last_month.at_beginning_of_month
          @end_day = @date_now.last_month.at_end_of_month
          @dates = (@start_day..@end_day).select {|x| x.monday?}
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        when 'month2' # 8周
          @start_day = @date_now.months_ago(2).at_beginning_of_month
          @end_day = @date_now.at_beginning_of_month.yesterday
          @dates = (@start_day..@end_day).select {|x| x.monday?}
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        when 'month3' # 12周
          @start_day = @date_now.months_ago(3).at_beginning_of_month
          @end_day = @date_now.at_beginning_of_month.yesterday
          @dates = (@start_day..@end_day).select { |x| x.monday? }
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('week', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        when 'month6' # 6月
          @start_day = @date_now.months_ago(6).at_beginning_of_month
          @end_day = @date_now.at_beginning_of_month.yesterday
          # 每月1号代表统计
          @dates = (@start_day..@end_day).select { |x| x.day == 1 }
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        when 'year' # 12月
          @start_day = @date_now.years_ago(1).at_beginning_of_year
          @end_day = @date_now.at_beginning_of_year.yesterday
          @dates = (@start_day..@end_day).select { |x| x.day == 1 }
          @date_statistics = @statistics.select("sum(amount) AS amount_sum, date_trunc('month', date(created_at)) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
        else
          @start_day = @date_now.last_week.at_beginning_of_week
          @end_day = @date_now.last_week.at_end_of_week
          # X轴日期
          @dates = (@start_day..@end_day).to_a
          # 日期统计
          @date_statistics = @statistics.select("sum(amount) AS amount_sum", "date(created_at) AS group_date").where(created_at: (@start_day..@end_day)).group("group_date")
      end
    end

    # 明细数据
    def results
      @statistics.includes(:product, :user).where(created_at: (@start_day..@end_day))
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
      orders.where(created_at: (@start_day..@end_day)).sum(:amount) - refunds.where(created_at: (@start_day..@end_day)).sum(:amount)
    end

    # 统计 预计销售收入额 销售收入增加-销售收入减少
    def profit_total(orders, refunds)
      orders.includes(:product).where(created_at: (@start_day..@end_day)).map(&:profit_amount).sum - refunds.includes(:product).where(created_at: (@start_day..@end_day)).map(&:profit_amount).sum
    end

  end
end
