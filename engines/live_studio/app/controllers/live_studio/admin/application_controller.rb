require_dependency "live_studio/application_controller"

module LiveStudio
  module Admin
    class ApplicationController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "admin_home"

      private

      def set_city
        @city = City.find_by(id: params[:city_id])
      end
    end
  end
end
