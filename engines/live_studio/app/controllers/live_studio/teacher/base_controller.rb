require_dependency "live_studio/application_controller"

module LiveStudio
  module Teacher
    class BaseController < ApplicationController
      layout "teacher_home"
      before_action :set_teacher

      def set_teacher
        @teacher = ::Teacher.find_by(id: params[:teacher_id]) || current_user
      end
    end
  end
end
