require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::CustomizedGroupsController < Station::ApplicationController
    layout 'v1/manager_home'

    def index
      @customized_groups = @workstation.live_studio_customized_groups
      @customized_groups = @customized_groups.uncompleted if params[:hide_completed].present?
      @query = @customized_groups.ransack(params[:q])
      @customized_groups = @query.result.order(id: :desc).paginate(page: params[:page])
    end
  end
end
