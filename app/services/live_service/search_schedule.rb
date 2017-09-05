module LiveService
  # 课程表查询
  class SearchSchedule
    def initialize(user)
      @user = user
    end

    def search_old(params = {})
      date = params['date'].try(:to_time)

      @search = ::LiveService::ScheduleServiceOld.schedule_for(@user)
      if params['date_type'] == 'week'
        @search_results = @search.week(date)
      else
        @search_results = @search.month(date)
      end

      if params['state'] == 'unclosed'
        @search_results = @search_results.select { |item| item.target.unclosed? }.sort_by { |item| item.target.start_at } if @user.student?
        @search_results = @search_results.select(&:unclosed?).sort_by(&:start_at) if @user.teacher?
      end

      if params['state'] == 'closed'
        @search_results = @search_results.select { |item| item.target.had_closed? }.sort_by { |item| item.target.start_at }.reverse if @user.student?
        @search_results = @search_results.select(&:had_closed?).sort_by(&:start_at).reverse if @user.teacher?
      end
      @search_results = @search_results.group_by { |item| item.target.class_date.to_s } if @user.student?
      @search_results = @search_results.group_by { |item| item.class_date.to_s } if @user.teacher?
      @search_results.map { |d, lessons| { date: d, lessons: lessons} }.sort_by { |x| x[:date] }
    end

    def search(params = {})
      date = params['date'].try(:to_time)

      @search = ::LiveService::ScheduleService.schedule_for(@user)
      if params['date_type'] == 'week'
        @search_results = @search.week(date)
      else
        @search_results = @search.month(date)
      end

      if params['state'] == 'unclosed'
        @search_results = @search_results.select { |item| item.target.unclosed? }.sort_by { |item| item.target.start_at } if @user.student?
        @search_results = @search_results.select(&:unclosed?).sort_by(&:start_at) if @user.teacher?
      end

      if params['state'] == 'closed'
        @search_results = @search_results.select { |item| item.target.had_closed? }.sort_by { |item| item.target.start_at }.reverse if @user.student?
        @search_results = @search_results.select(&:had_closed?).sort_by(&:start_at).reverse if @user.teacher?
      end
      @search_results = @search_results.group_by { |item| item.target.class_date.to_s } if @user.student?
      @search_results = @search_results.group_by { |item| item.class_date.to_s } if @user.teacher?
      @search_results.map { |d, lessons| { date: d, lessons: lessons} }.sort_by { |x| x[:date] }
    end
  end
end
