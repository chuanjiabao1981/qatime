require_dependency "live_studio/manager/base_controller"

module LiveStudio
  class Manager::InviationsController < Manager::BaseController
    before_action :set_manager


    def index
      @inviations = @manaer.manager_inviations.paginate(page: params[:page], per_page: 10)
    end


    private

    def set_manager
      @manaer = ::Manager.find(params[:manager_id])
    end

  end
end
