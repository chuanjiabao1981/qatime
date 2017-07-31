require_dependency "live_studio/application_controller"

module LiveStudio
  class Student::CustomizedGroupsController < Student::BaseController
    layout 'v1/home'

    def index
      @customized_groups = @student.live_studio_bought_customized_groups
      @customized_groups = @customized_groups.where(status: filter_status).includes(:teacher).paginate(page: params[:page])
    end

    private

    def filter_status
      LiveStudio::Course.statuses[params[:status] || 'published']
    end
  end
end
