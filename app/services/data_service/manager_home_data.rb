module DataService
  class ManagerHomeData
    def initialize(workstation)
      @workstation = workstation
    end

    # 销售统计
    def statistics(options = {})
      options[:genre] ||= 'order'
      options[:statistics_days] ||= ::Payment::Transaction.statistics_days.default_value
      @refund_statistics = @workstation.refunds.refunded
      @order_statistics = @workstation.orders.valid_order

      if options[:genre] == 'refund'
        @statistics = @refund_statistics
      else
        @statistics = @order_statistics
      end

      @searchable = StatisticService::TransactionDirector.new(@statistics, options[:statistics_days], Time.now)
      @searchable.search(options)
      # @x_cate = ['2-12', '2-13', '2-14', '2-15', '2-16', '2-17', '2-18']
      # @series_data = [0, 600, 300, 134, 90, 230, 200]
    end

    def statistics_x_cate
      @searchable.x_cate
    end

    def statistics_series_data
      @searchable.series_data
    end

    def statistics_sales_total
      @searchable.sales_total(@order_statistics, @refund_statistics)
    end

    def statistics_results
      @searchable.results
    end
    # 销售统计 END

    # 实时动态
    def action_records
      @workstation.action_records.order(id: :desc)
    end

    # 正在上课
    def teaching_lessons
      lessons = @workstation.live_studio_lessons.includes(:course).teaching
      interactive_lessons = @workstation.live_studio_interactive_lessons.includes(:interactive_course).teaching
      all_lessons = lessons.to_a + interactive_lessons.to_a
      all_lessons.sort_by { |x| x.start_at }
    end

    # 考核进度
    def waiting_tasks
      @workstation.sale_tasks.ongoing.reorder(started_at: :asc)
    end

  end
end
