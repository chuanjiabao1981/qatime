require_dependency "live_studio/application_controller"

module LiveStudio
  module Manager
    class BaseController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "manager_home"
      before_action :set_manager
      include ::LiveStudio::SessionsHelper


      private
      def set_manager
        @manager ||= ::Manager.find(params[:manager_id])
      end
      # def current_resource
      #   @current_resource ||= ::Manager.find(params[:manager_id])
      #   @current_variable ||= Course.find_by(id: params[:id]) if params[:controller].include?('courses')
      #   [@current_resource,@current_variable]
      # end
    end
  end
end
