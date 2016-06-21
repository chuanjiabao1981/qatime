require_dependency "live_studio/application_controller"

module LiveStudio
  module Teacher
    class BaseController < ApplicationController
      layout "teacher_home"
      before_action :set_teacher

      def set_teacher
        @teacher = current_user
      end
    end
  end
end
