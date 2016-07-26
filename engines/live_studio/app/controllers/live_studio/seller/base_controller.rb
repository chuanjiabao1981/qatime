require_dependency "live_studio/application_controller"

module LiveStudio
  module Seller
    class BaseController < ApplicationController
      layout "seller_home"
      before_action :set_user
      include ::LiveStudio::SessionsHelper

      private
      def set_user
        @seller ||= ::Seller.find(params[:seller_id])
      end
    end
  end
end
