require_dependency "social/application_controller"

module Social
  class Station::FeedsController < ApplicationController
    layout 'v1/manager_home'

    before_action :set_workstation

    def index
      @feeds = Social::Feed.where(workstation: @workstation).order('id desc').includes(:feedable, :producer, :target, :linkable).paginate(page: params[:page])
    end

    private

    def set_workstation
      @workstation ||= Workstation.find(params[:workstation_id])
    end

    def current_resource
      set_workstation
    end
  end
end
