require_dependency "live_studio/application_controller"

module LiveStudio
  module Teacher
    class BaseController < ApplicationController
      layout "teacher_home"
    end
  end
end
