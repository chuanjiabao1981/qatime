require_dependency "live_studio/application_controller"

module LiveStudio
  module Manager
    class BaseController < ApplicationController
      # layout 'live_studio/layouts/application'
      layout "manager_home"
    end
  end
end
