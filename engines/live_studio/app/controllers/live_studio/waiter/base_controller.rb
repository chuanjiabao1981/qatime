require_dependency "live_studio/application_controller"

module LiveStudio
  module Waiter
    class BaseController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "waiter_home"
      before_action :current_resource

      private
      def current_resource
        @waiter ||= ::Waiter.find_by(id: params[:waiter_id])
      end
    end
  end
end
