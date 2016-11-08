require_dependency "live_studio/manager/base_controller"

module LiveStudio
  class Manager::InviationsController < Manager::BaseController
    before_action :set_manager


    def index
      @inviations = @manager.manager_inviations.paginate(page: params[:page], per_page: 10)
    end

    def show
      @old_inviation = @manager.manager_inviations.find(params[:id])
      @inviation =  ::ManagerInviation.new
    end

    def new
      @inviation = ::ManagerInviation.new
    end

    def edit

    end

    def create
      @inviation = @manager.manager_inviations.new(inviation_params)
      @inviation.generate_attribute(inviation_params)
      if @inviation.save
        redirect_to manager_inviations_path(@manager), notice: i18n_notice('created', @inviation)
      else
        render :new
      end
    end

    def update

    end

    def destroy

    end

    def cancel
      inviation = @manager.manager_inviations.find(params[:id])
      if inviation.update(status: 'cancelled')
        redirect_to manager_inviations_path(@manager)
      end
    end

    private

    def set_manager
      @manager = ::Manager.find(params[:manager_id])
    end

    def inviation_params
      params.require(:manager_inviation).permit(
        :parent_phone, :teacher_percent, :expited_day
      )
    end

  end
end
