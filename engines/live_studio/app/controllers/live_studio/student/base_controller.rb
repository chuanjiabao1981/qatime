require_dependency "live_studio/application_controller"

module LiveStudio
  module Student
    class BaseController < ApplicationController
      layout 'student_home'
    end
  end
end
