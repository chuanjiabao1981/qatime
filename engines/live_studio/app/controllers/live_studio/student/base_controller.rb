require_dependency "live_studio/application_controller"

module LiveStudio
  module Student
    class BaseController < ApplicationController
      layout 'student_home'

      before_action :set_student

      private
      def set_student
        @student = current_user
      end
    end
  end
end
