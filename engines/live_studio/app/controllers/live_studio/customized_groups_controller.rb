require_dependency "live_studio/application_controller"

module LiveStudio
  class CustomizedGroupsController < ApplicationController
    before_action :find_workstation, except: [:index, :show]

    def index
    end

    def show
    end

    private

    def set_customized_group
      @customized_group = CustomizedGroup.find(params[:id])
    end

    def find_workstation
      if params[:workstation_id].present?
        @workstation = ::Workstation.find(params[:workstation_id])
      end
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      CustomizedGroup.find(params[:id]) if params[:id]
    end
  end
end
