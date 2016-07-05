require_dependency "live_studio/application_controller"

module LiveStudio
  module Manager
    class BaseController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "manager_home"
      before_action :set_manager

      private

      def set_manager
        @manager = Account.find(current_user.id)
      end
    end
  end
end
