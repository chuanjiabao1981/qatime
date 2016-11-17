require_dependency "live_studio/application_controller"

module LiveStudio
  module Admin
    class ApplicationController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "admin_home"
    end
  end
end
