require_dependency "live_studio/application_controller"

module LiveStudio
  module Seller
    class BaseController < ApplicationController
      layout "seller_home"
      before_action :current_resource

      private
      def current_resource
        @current_resource ||= ::Seller.find(params[:seller_id])
      end
    end
  end
end
