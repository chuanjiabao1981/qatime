class Managers::HomeController < ApplicationController
  respond_to :html
  layout "manager_home"

  before_action :set_workstation

  def main
    home_data = DataService::ManagerHomeData.new(@workstation)
    @action_records = home_data.action_records.limit(10)
    home_data.statistics(statistics_days: params[:statistics_days])
    @sales_total = home_data.statistics_sales_total
    @x_cate = home_data.statistics_x_cate
    @series_data = home_data.statistics_series_data
    @teaching_lessons = home_data.teaching_lessons[0..2]
  end

  private
  def set_workstation
    if params[:workstation_id]
      @workstation = Workstation.find(params[:workstation_id])
    else
      @workstation = current_user.workstations.first
    end
    @city = @workstation.city
  end

end
