require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::CustomizedGroupsController < Teacher::BaseController
    layout 'v1/home'

    def index
      @customized_groups = @teacher.live_studio_customized_groups
      @customized_groups = @customized_groups.where(status: LiveStudio::CustomizedGroup.statuses[params[:cate].to_sym]) if %w(published teaching completed).include?(params[:cate])
      @customized_groups = @customized_groups.order(id: :desc).paginate(page: params[:page])
    end
  end
end
