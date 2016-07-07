require_dependency "live_studio/application_controller"

module LiveStudio
  module Manager
    class BaseController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "manager_home"
      before_action :current_resource
      before_action :set_manager

      private
      def current_resource
        @current_resource ||= ::Manager.find(params[:manager_id])
      end

      def set_manager
        @manager = current_resource
      end
    end
  end
end
