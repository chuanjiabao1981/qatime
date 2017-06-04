# 工作站主页
class Station::HomeController < Station::BaseController
  layout 'v1/manager_home'

  def index
    home_data = DataService::ManagerHomeData.new(@workstation)
    @action_records = home_data.action_records.limit(10)
    home_data.statistics(statistics_days: params[:statistics_days])
    @sales_total = home_data.statistics_sales_total
    @x_cate = home_data.statistics_x_cate
    @series_data = home_data.statistics_series_data
    @teaching_lessons = home_data.teaching_lessons[0..2]
    @waiting_tasks = home_data.waiting_tasks
  end
end
