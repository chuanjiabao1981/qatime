require_dependency "recommend/application_controller"

module Recommend
  class Station::ApplicationController < ApplicationController
    layout 'v1/manager_home'

    before_action :set_workstation

    private

    def set_workstation
      @workstation ||= ::Workstation.find(params[:workstation_id])
    end

    def current_resource
      set_workstation
    end
  end
end
